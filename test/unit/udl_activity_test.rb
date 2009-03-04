require 'test_helper'

class ActivityTest < Test::Unit::TestCase
  
  # context "with mocked bundles" do
  #     setup do
  #        mock_up('localhost')
  #         bundles = []
  #         ActiveResource::HttpMock.respond_to do |mock|
  #           1.upto(10) do | number |
  #             bundles[number] = { 
  #               :id => number, 
  #               :sail_session_uuid => "%.4d" % number 
  #             }.to_xml(:root => 'bundle')
  #             mock.get    "/13/bundles/#{number}.xml",       {}, bundles[number]
  #           end
  #           mock.get    "/13/bundles.xml",            {}, "<bunldes>#{bundles.join("\n")}</bundles>"  
  #         end
  #         
  #         @bundle_a = Bundle.find(1)
  #         @bundle_b = Bundle.find(2)
  #         @bundle_c = Bundle.find(3)
  #     end
  #     teardown do
  #       de_mock
  #     end
  #     context "Unfetched Bundles" do    
  #         should "have a good collection path" do
  #           assert_equal '/13/bundles.xml', Bundle.collection_path
  #         end
  #     end
  # end
  
  context "using remote udl activities" do
    setup do
      de_mock
    end
    should "find some remote activities" do
      activities = UdlActivity.find(:all)
      assert activities.size > 1
    end
    
    should "find an activity for an offering" do
      activity = UdlActivity.find_by_offering(8642)
      assert_not_nil activity
    end
  end
  
  context "with mocked udl activities" do
    setup do
      mock_up('localhost')
      ActiveResource::HttpMock.respond_to do |mock|
          mock.get    "/external_otrunk_activities/1.xml",       {}, { :id=>1,:name=>"test", :user_id=>"1" }.to_xml(:root => 'udl_activity')
      end
      @activity = UdlActivity.find(1)
    end
    
    teardown do
      de_mock
    end
    
    should "know its sds otml url" do
      assert_not_nil @activity.sds_otml
      # http://udl.diy.concord.org/external_otrunk_activities/1/otml/6/1
      assert_equal "#{UdlActivity::site}#{UdlActivity::element_name.pluralize}/1/otml/6/1",@activity.sds_otml
    end
  end
    
end
  