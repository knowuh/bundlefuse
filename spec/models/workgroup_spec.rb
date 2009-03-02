require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

context "An existing workgroup" do

  describe Workgroup do
    @workgroup = Workgroup.find(32848)

    it "should not be nil" do
      @workgroup.should_not be_nil
    end
    
    it "should find Shana Woodell" do
      @workgroup.name == "Shana Woodell"
    end
  end
  
end