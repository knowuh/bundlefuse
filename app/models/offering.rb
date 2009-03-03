class Offering < ActiveResource::Base
  # TODO: dont hardcode he server address!
  self.site = "http://localhost:3000/"
  # TODO  : Portal prefix should NOT be hard-coded.
  self.prefix='/13/' #thats UDL
  self.element_name= "offering"
  self.collection_name= "offering"
end
