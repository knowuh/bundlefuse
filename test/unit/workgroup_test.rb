require 'test_helper'

class WorkGroupTest < Test::Unit::TestCase

  context "unfetched workgroup" do    
      should "have valid collection path" do
        assert_equal '/13/workgroups.xml', Workgroup.collection_path
      end
  end
  
  context "fetching workgroups" do
    setup do
      @workgroup = Workgroup.find(32848)
    end
    
    should "find workgroup" do
      assert !@workgroup.nil?
    end
  end
  
  
end
