class Offering < ActiveResource::Base
  # TODO: dont hardcode the server address!
  self.site = "http://saildataservice/"
  # TODO  : Portal prefix should NOT be hard-coded.
  self.prefix='/13/' #thats UDL
end
