require 'test_helper'

class NodeTest < Test::Unit::TestCase
  require 'active_resource/http_mock'
  context "new Node" do 
      setup do
        @node = Node.create(:bundle_id => 1)
      end
      
      should  "not be nil" do
        assert @node
      end
      
      should "have not have a parent" do
        assert_nil @node.parent
      end
  end

  context "with mocked bundles" do
    setup do
        bundles = []
        mock_up('localhost')
        ActiveResource::HttpMock.respond_to do |mock|
          1.upto(10) do | number |
            bundles[number] = { 
              :id => number, 
              :sail_session_uuid => "%.4d" % number 
            }.to_xml(:root => 'bundle')
            mock.get    "/13/bundles/#{number}.xml",       {}, bundles[number]
          end
            mock.get    "/13/bundles.xml",  {}, "<bundles>#{bundles.join("\n")}</bundles>"  
        end
        
        @bundle_a = Bundle.find(1)
        @bundle_b = Bundle.find(2)
        @bundle_c = Bundle.find(3)
    end
    teardown do
      de_mock
    end
     
    should "have functioning http mocks objects" do
      assert_not_nil Bundle.get(1)
      assert_not_nil Bundle.get(2)
      assert_not_nil Bundle.get(3)
    end
    
    
    context "Nodes created by bundles" do
         should "be the same if they are created by the same bundles" do
           @node = Node.for_bundle(@bundle_a)
           @second_node = Node.for_bundle(@bundle_a)
           assert_equal @node,@second_node
         end
       
         should "be not be the same if they are created by different bundles" do
           @node = Node.for_bundle(@bundle_a)
           @second_node = Node.for_bundle(@bundle_b)
           assert_not_equal @node,@second_node
         end
       
         should "be the same if they are made from differing instances of the same bundle" do
           @node = Node.for_bundle(@bundle_b)
           @second_node = Node.for_bundle(Bundle.find(2))
           assert_equal @node,@second_node
         end
       end
         
       context "parent with one child" do
         setup do
           @parent = Node.create(:bundle_id => 2)
           @child  = Node.create(:bundle_id => 3)
           @parent.children << @child
         end
       
         should "have one child" do
           assert_equal 1,@parent.children.size
         end
       
         should "have child with parent which is itself" do
           assert_equal @child.parent, @parent
           assert_equal @parent.children.first.parent, @parent
         end
       
         should "have a child with a root of itself" do
           assert_equal @child.root, @parent
         end
       end
         
       context "parent with two children" do
         setup do
           @parent = Node.create(:bundle_id => 1)
           @child_a  = Node.create(:bundle_id => 2)
           @child_b = Node.create(:bundle_id => 3)
           @parent.children << @child_a << @child_b
         end
       
         should "have two children" do
           assert_equal 2,@parent.children.size
         end
       
         should "have 2 descendants" do
           assert_equal 2,@parent.descendants.size
         end
       
         should "have 2 leaves" do
           assert_equal 2,@parent.leaves.size
         end
       end
         
                  
       context "nesting of three generations" do
         setup do
           @grampa = Node.create(:bundle_id => 4)
           @papa  = Node.create(:bundle_id => 5)
           @baby = Node.create(:bundle_id => 6)
           @grampa.children << @papa
           @papa.children << @baby
         end
         
         should "have the same grandpa" do
           assert_equal @grampa,@grampa.root
           assert_equal @grampa,@papa.root
           assert_equal @grampa,@baby.root
         end
       
         should "mean that grampa has 2 descendants" do
           assert_equal 2,@grampa.descendants.size
         end
       
         should "have only one leaf" do
           assert_equal 1,@grampa.leaves.size
         end
       
         should "have two linears" do
           assert_equal 2,@grampa.linears.size
         end
       end
  end
  
  context "with Shana Woodell workgroup" do
    setup do
      de_mock
      @bundle = Bundle.find(76566)  # UDL Shana Woodell 
      @workgroup = @bundle.workgroup
      puts 
    end
     
    should "be a belonging to Shanna" do
      assert_not_nil @bundle
      assert_not_nil @workgroup
      assert @workgroup.name == "Shana Woodell"
    end
    
    should "create a set of nodes from workgroup" do
      assert_not_nil @workgroup
      node = Node::for_workgroup(@workgroup)
      assert_not_nil node
      puts node
      puts "waiting for user input"
      gets
    end
  end
end
