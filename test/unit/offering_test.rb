require 'test_helper'

class OfferingTest < Test::Unit::TestCase
  
  context "unmocked offerings" do
    setup do
      de_mock
    end
    
    should "have a good collection path" do
      puts Offering.collection_path
    end
    
    should "return valid offerings when we list them" do
      @offerings = Offering.find(:all)
      puts @oferings.to_xml
    end
    
  end
end
