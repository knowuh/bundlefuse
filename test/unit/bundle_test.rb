require 'test_helper'

class BundleTest < Test::Unit::TestCase
  
  context "with mocked bundles" do
    setup do
       mock_up('localhost')
        bundles = []
        ActiveResource::HttpMock.respond_to do |mock|
          1.upto(10) do | number |
            bundles[number] = { 
              :id => number, 
              :sail_session_uuid => "%.4d" % number,
              :sail_session_start_time => Time.now,
              :sail_session_end_time => Time.now
            }.to_xml(:root => 'bundle')
            mock.get    "/13/bundles/#{number}.xml",       {}, bundles[number]
          end
          mock.get    "/13/bundles.xml",            {}, "<bunldes>#{bundles.join("\n")}</bundles>"  
        end
        
        @bundle_a = Bundle.find(1)
        @bundle_b = Bundle.find(2)
        @bundle_c = Bundle.find(3)
    end
    teardown do
      de_mock
    end
    
    context "Unfetched Bundles" do    
        should "have a good collection path" do
          assert_equal '/13/bundles.xml', Bundle.collection_path
        end
    end



    context "remote un-mocked bundles" do
      setup do
        de_mock
        @bundle = Bundle.find(76566)  # UDL Shana Woodell 
      end
      
      should "have fetch data" do
        assert_not_nil @bundle
        puts @bundle.to_xml
      end
      
      should "have existing bundle contents" do
        @contents = @bundle.contents
        assert_not_nil @contents
        puts @contents.to_xml
      end
      
      should "have good learner data" do
        @learner_data = @bundle.contents.learner_data
        assert_not_nil @learner_data
        puts @learner_data.to_xml
      end
      
      should "should merge learner data" do
        
      end
    end
    
  end
end
  