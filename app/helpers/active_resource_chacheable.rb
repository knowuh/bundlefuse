# it would be good to implement a before and after find which would store things in memory for a bit, hashed on db_id or something...
# sounds pretty easy.
# module ActiveResource
#   module Cacheable
#     CALLBACKS = %w( after_save after_destroy )
#     
#     def self.included(base)
#       [:save, :destroy].each do |method|
#         base.send :alias_method_chain, method, :callbacks
#       end
#       
#       base.send :include, ActiveSupport::Cacheable
#       base.define_callbacks *CALLBACKS
#     end
#     
#     def save_with_callbacks
#       returning save_without_callbacks do
#         run_callbacks(:after_save) unless new?
#       end
#     end
#     
#     def destroy_with_callbacks
#       returning destroy_without_callbacks do
#         run_callbacks(:after_destroy)
#       end
#     end
#   end
# end
# 
# ActiveResource::Base.send :include, ActiveResource::Cacheable