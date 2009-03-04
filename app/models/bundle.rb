class Bundle < ActiveResource::Base
  # TODO: dont hardcode he server address!
  #  self.site = "http://saildataservice.concord.org/"
  self.site = "http://saildataservice/"
  self.prefix='/13/'

  def contents
    return BundleContents.find(bundle_content_id)
  end
  
  def workgroup
    Workgroup.find(workgroup_id)  
  end
  
  def config
    offering_id = workgroup.offering_id
    portal_id = workgroup.portal_id
    return "#{Bundle::site}#{portal_id}/offering/#{offering_id}/config/#{workgroup.id}/1/bundle/#{id}"
  end

  def udl_activity
    UdlActivity.find_by_offering(workgroup.offering_id)
  end
  
  def jnlp
    offering_id = workgroup.offering_id
    portal_id = workgroup.portal_id
    return "#{Bundle::site}#{portal_id}/offering/#{offering_id}/jnlp/#{workgroup.id}/bundle/#{id}"
  end
  
  def udl_launch_url
    activity = udl_activity
    otml_url = activity.sds_otml
    otml_filename = activity.short_name
    return make_sds_url(jnlp,
      { :sailotrunk_otmlurl => otml_url,
        :jnlp_filename => otml_filename
      # :jnlp_properties => "sailotrunk.hidetree=false"
      })
  end
  
end
