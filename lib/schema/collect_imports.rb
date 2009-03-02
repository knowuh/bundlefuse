Dir.chdir ARGV[0] unless ARGV.empty?
$stderr.puts "1) parsing all otml files located in this dir tree: #{ARGV[0]},"
$stderr.puts "2) extracting all <import> elements"
$stderr.puts "3) writing unique set to: /tmp/all-otrunk.xml"
File.open('/tmp/all-otrunk.xml','w') do |f| 
  f.write "<otrunk>\n"
  f.write `find . -name "*.otml" -print0 | xargs -0  egrep -h -o "<import class=.*" | sed 's/ *\\/>.*/\\/>/' | sort | uniq`
  f.write "</otrunk>\n"
end