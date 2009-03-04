#!/usr/bin/env ruby
# done: 'successfully' merged some OTML documents
# created some activeresource tests and mocks (debugged that a lot yesterday, finally have a good grip on it)
# wrote some minimal documentation
# hit some blocks with SDS JNLP launch properties which I am trying to classify
# started thinking about more general OTML manipulation classes


# Test how to request a JNLP with launch properties specifying a specific bundle file for learner data.
@host='localhost'
@port=3000

bundle_id = ARGV[0] || 79332
puts "loading bundle information for #{bundle_id}..."
bundle = Bundle.find(bundle_id)
  
workgroup = Workgroup.find(bundle.workgroup_id)
puts "verify: bundle #{bundle_id} belongs to #{workgroup.name} (id:#{workgroup.id})"

puts "\n\nBundle Config URL for this bundke is: #{bundle.config}"
# %x[open #{bundle.config}]
puts "jnlp url is : #{bundle.jnlp}"
puts "calling open on this JNLP url: #{bundle.udl_launch_url}"
puts bundle.udl_activity.to_xml
%x[open #{bundle.udl_launch_url}]

# puts bundle.contents.to_xml
# puts bundleconfig(bundle.offering_id,bundle.workgroup_id,bundle.id)