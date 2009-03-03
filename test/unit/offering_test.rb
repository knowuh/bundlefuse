require 'test_helper'

class OfferingTest < Test::Unit::TestCase

  context "unfetched offering" do    
      should "have valid collection path" do
        assert_equal '/13/offerings.xml', Offering.collection_path
      end
  end
  
  context "un-mocked behavior" do
    setup do
      @offering = Offering.find(8642)
      @list = Offering.find(:all)
    end
    
    should "find some offerings" do
      assert @list.size > 0
    end
    
    should "find a known offering" do
      assert_not_nil @offering
    end
  end
  
  
end
