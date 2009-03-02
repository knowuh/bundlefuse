require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

context "Without fetching data" do
  describe Bundle do
    
    it "should have a valid collection point" do
       puts Bundle.collection_path
       Bundle.collection_path.should be "/13/bundles.xml"
    end
  end
  
end

context "An existing bundle" do

  # describe Bundle do
  #  @bundle = Bundle.find(76566)
  #
  #  it "should not be nil" do
  #    @bundle.should_not be_nil
  #  end 
  #end
  
end