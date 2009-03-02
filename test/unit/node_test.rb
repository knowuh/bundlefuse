require 'test_helper'

class NodeTest < Test::Unit::TestCase

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
  
  context "Nodes created by bundles" do
    setup do
      
      @bundle_a  = { 
        :id => 1, 
        :sail_session_uuid => '001' }.to_xml(:root => 'bundle')
      @bundle_b  = { :id => 2, :sail_session_uuid => '002' }.to_xml(:root => 'bundle')

      ActiveResource::HttpMock.respond_to do |mock|
        mock.get    "/13/bundle/1.xml",          {}, @bundle_a
        mock.get    "/13/bundle/2.xml",          {}, @bundle_b
        mock.get    "/13/bundle/3.xml",          {}, @bundle_c
        mock.get    "/people.xml",               {}, "<people>#{@matz}#{@david}</people>"
      end
      
      
      @bundle_a = Bundle.new
      @bundle_a.id=11
      @bundle_b = Bundle.new
      @bundle_b.id=12
      @bundle_c = Bundle.new
      @bundle_c.id=12
    end
    
    should "nodes created from the same bundle are the same" do
      @node = Node.forbundle(@bundle_a)
      @second_node = Node.forbundle(@bundle_a)
      assert_equal @node,@second_node
    end
    
    should "nodes created from different bundle are not the same" do
      @node = Node.forbundle(@bundle_a)
      @second_node = Node.forbundle(@bundle_b)
      assert_not_equal @node,@second_node
    end
    
    should "nodes created from different bundle with the same id are the same" do
      @node = Node.forbundle(@bundle_b)
      @second_node = Node.forbundle(@bundle_c)
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
