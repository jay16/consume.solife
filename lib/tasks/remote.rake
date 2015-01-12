#encoding: utf-8
require "net/ssh"
require "net/scp"
desc "remote deploy application."
namespace :remote do
  def encode(data)
    data.to_s.encode('UTF-8', {:invalid => :replace, :undef => :replace, :replace => '?'})
  end

  def execute!(ssh, command)
    puts "\t`%s`" % command
    ssh.exec!(command) do  |ch, stream, data|
      begin
        puts "\t\t%s: %s" % [stream, data]
      rescue
        puts "\t\t%s: %s" % [stream, encode(data)]
      end
    end
  end

  desc "scp local config files to remote server."
  task :deploy => :environment do
    remote_root_path = Setting.server.app_root_path
    local_config_path  = "%s/config" % Rails.root
    remote_config_path = "%s/config" % remote_root_path
    yamls = Dir.entries(local_config_path).find_all { |file| File.extname(file) == ".yaml" }
    Net::SSH.start(Settings.server.host, Settings.server.user, :password => Settings.server.password) do |ssh|
      _dirname  = File.dirname(remote_root_path)
      _basename = File.basename(remote_root_path)
      command = "cd %s && git reset --hard HEAD && git pull origin master" % remote_root_path
      execute!(ssh, command)

      command = "cd %s && bundle install --local" % remote_root_path
      execute!(ssh, command)

      command = "cd %s && bundle exec rake assets:precompile RAILS_ENV=production" % remote_root_path
      execute!(ssh, command)

      # check whether remote server exist yaml file
      yamls.each do |yaml|
        command = "test -f %s/%s && echo '%s - exist' || echo '%s - not found.'" % [remote_config_path, yaml, yaml, yaml]
        execute!(ssh, command)
        ssh.scp.upload!("%s/%s" % [local_config_path, yaml], remote_config_path) do |ch, name, sent, total| 
          print "\rupload #{name}: #{(sent.to_f * 100 / total.to_f).to_i}%"
        end
        puts "\n"
      end
    end
  end
end
