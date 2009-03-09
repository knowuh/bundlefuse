class Bundle < ActiveResource::Base
  # TODO: dont hardcode he server address!
  #  self.site = "http://saildataservice.concord.org/"
  self.site = "http://saildataservice/"
  self.prefix='/13/'

  def contents
    unless @contents
      @contents =  BundleContents.find(bundle_content_id)
    end
    @contents
  end
  
  def workgroup
    unless @workgroup
      @workgroup = Workgroup.find(workgroup_id)  
    end
    @workgroup
  end
  
  def config
    offering_id = workgroup.offering_id
    portal_id = workgroup.portal_id
    return "#{Bundle::site}#{portal_id}/offering/#{offering_id}/config/#{workgroup.id}/1/bundle/#{id}"
  end

  def udl_activity
    unless @udl_activity
      @udl_activity = UdlActivity.find_by_offering(workgroup.offering_id)
    end
    @udl_activity
  end
  
  def jnlp
    offering_id = workgroup.offering_id
    portal_id = workgroup.portal_id
    return "#{Bundle::site}#{portal_id}/offering/#{offering_id}/jnlp/#{workgroup.id}/bundle/#{id}"
  end
  
  def udl_launch_url
    unless @udl_launch_url
      activity = udl_activity
      # otml_url = activity.sds_otml
      # TODO: probably should not do this directly actually. Best to read the overlay_otml and fetch OTML out.
      otml_url = sailotrunk_otmlurl.gsub('overlay_otml','otml')
      otml_filename = activity.short_name
      @udl_launch_url =  make_sds_url(jnlp,
        { :sailotrunk_otmlurl => otml_url,
          :jnlp_filename => otml_filename
        # :jnlp_properties => "sailotrunk.hidetree=false"
        })
    end
    @udl_launch_url  
  end
  
end
