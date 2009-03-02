require 'test_helper'


class BundleTest < Test::Unit::TestCase
  
  secontext "with mocked bundles" do
    setup do
        bundles = []
        ActiveResource::HttpMock.respond_to do |mock|
          1.upto(10) do | number |
            bundles[number] = { 
              :id => number, 
              :sail_session_uuid => "%.4d" % number 
            }.to_xml(:root => 'bundle')
            mock.get    "/13/bundles/#{number}.xml",       {}, bundles[number]
          end
          mock.get    "/13/bundles.xml",            {}, "<bunldes>#{bundles.join("\n")}</bundles>"  
        end
        
        @bundle_a = Bundle.find(1)
        @bundle_b = Bundle.find(2)
        @bundle_c = Bundle.find(3)
    end
  
    context "Unfetched Bundles" do    
        should "have a good collection path" do
          assert_equal '/13/bundles.xml', Bundle.collection_path
        end
    end
    
  end
end
  