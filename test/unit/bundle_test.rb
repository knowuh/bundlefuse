require 'test_helper'


class BundleTest < Test::Unit::TestCase
  
  setup do
    @bundle_a  = { 
      :id => 1, 
      :sail_session_uuid => '001' 
    }.to_xml(:root => 'bundle')
    @bundle_b  = { 
      :id => 2, 
      :sail_session_uuid => '002' 
    }.to_xml(:root => 'bundle')
    @bundle_c  = { 
      :id => 3, 
      :sail_session_uuid => '002' 
    }.to_xml(:root => 'bundle')

    # @bundle_list = [@bundle_a,@bundle_c, @bundle_d].to_xml(:root => 'bundles')
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get    "/13/bundle/1.xml",          {}, @bundle_a
      mock.get    "/13/bundle/2.xml",          {}, @bundle_b
      mock.get    "/13/bundle/3.xml",          {}, @bundle_c
    end
  end
  
  context "Unfetched Bundle" do    
      should "have a good collection path" do
        assert_equal '/13/bundles.xml', Bundle.collection_path
      end
  end
end
  