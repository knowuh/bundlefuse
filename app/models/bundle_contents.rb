class BundleContents < ActiveResource::Base
  # TODO: dont hardcode he server address!
  self.site = "http://saildataservice/"
  self.prefix='/13/'
  
  def learner_data
    (self.get(:ot_learner_data)).to_xml
  end
end

