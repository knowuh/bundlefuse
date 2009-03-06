class UdlActivity < ActiveResource::Base
  # TODO: dont hardcode he server address!
  # self.site = "http://udl.diy.concord.org/"
  self.site="http://localhost:3001"
  self.element_name="external_otrunk_activity"
  
  def UdlActivity::find_by_offering(sds_id)
    # note: we should check our rest-fulness on the portal side.  Ideally we would like
    # to limit the responses... for now, we select them all.
    activs =  UdlActivity.find(:all, :params => { :sds_offering_id  => sds_id })
    return (activs.select { |a| a.sds_offering_id == sds_id }).first
  end
  
  def sds_otml
    # example: http://udl.diy.concord.org/external_otrunk_activities/1/overlay_otml/6/2022
    # more info: http://udl.diy.concord.org/external_otrunk_activities/1/overlay_otml/<SERIAL_VENDOR_ID>/<USER_ID>
    # return "#{UdlActivity::site}#{UdlActivity::element_name.pluralize}/#{id}/overlay_otml/6/#{user_id}"
    return "#{UdlActivity::site}#{UdlActivity::element_name.pluralize}/#{id}/otml/6/#{user_id}"
  end
  
end
