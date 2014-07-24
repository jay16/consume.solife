#!/usr/bin/env ruby
require "optparse"

#store options in hash
options = {}
opt_parse = OptionParser.new do |opts|
  opts.banner = 'custom passenger setup config.'
  opts.separator  ""
  opts.separator  "Options"

  # This displays the help screen, all programs are
  # assumed to have this option.
  opts.on('-h', '--help', 'display this usage page') do
    puts opts; exit
  end

  opts.on('-e environment', '--environment', String, 'production/development/test') do |value|
    options[:environment] = value.to_s
  end

  opts.on('-d dbbak', '--dbbak', String, 'true/false') do |value|
    options[:dbbak] = (value == "true")
  end

  opts.on('-c precompile', '--precompile', String, 'true/false') do |value|
    options[:precompile] = (value == "true")
  end

  opts.separator  ""
  opts.separator  "Commands"
  opts.separator  "     ./passenger.rb -e production -d false -c true"
end

begin
  opt_parse.parse!
rescue => e
  puts opt_parse;  exit
end

puts "Make Sure MySQL start!"
`mysql.server start`

if options[:dbbak]
  puts "Sync Consume DB from remote VPS In Background!"
  `nohup /usr/local/var/rbenv/shims/ruby /Users/lijunjie/Code/crond/sync_consume_db.rb > ./log/nohup.syncDB.log 2>&1 &`
end

if options[:precompile]
  puts "rake assets:procompile runing..."
  `cd #{Dir.pwd} && bundle exec rake assets:procompile`
end

if options[:environment]
  #sudo lsof -i:3000
  `cd #{Dir.pwd} && passenger start -e #{options[:environment]}`
else
  `cd #{Dir.pwd} && passenger start`
end
