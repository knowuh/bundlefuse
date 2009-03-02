require 'test_helper'

class BundleTest < Test::Unit::TestCase
  
  context "Unfetched Bundle" do    
      should "have a good collection path" do
        assert_equal '/13/bundles.xml', Bundle.collection_path
      end
  end
end
  