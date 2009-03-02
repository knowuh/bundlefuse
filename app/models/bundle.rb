class Bundle < ActiveResource::Base
  # TODO: dont hardcode he server address!
  self.site = "http://localhost:3000/"
  self.prefix='/13/'
end
