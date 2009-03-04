class BundleContents < ActiveResource::Base
  # TODO: dont hardcode he server address!
  self.site = "http://saildataservice/"
  self.prefix='/13/'
end

