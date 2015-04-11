# config valid only for current version of Capistrano
lock '3.4.0'

set :stage, "production"
set :stages, %w(production)

# rbenv
# set :rbenv_type, :user # or :system, depends on your rbenv setup
# set :rbenv_ruby, '1.9.3p392'
# set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
# set :rbenv_map_bins, %w{rake gem bundle ruby rails}

set :application, 'consume'
set :deploy_user, 'jay'
set :deploy_host, "solife.us"
# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/work/%s" % fetch(:application)

set :repo_url, 'git@github.com:jay16/consume.solife.git'
# Default value for :scm is :git
set :scm, :git
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, :master



set :user, "jay"
set :group, "jay"

set :runner, "jay"
set :use_sudo, false

set :rails_env, "production"

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :default_env, { path: "/root/.rbenv/versions/1.9.3-p392/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

role :web, "solife.us" # Your HTTP server, Apache/etc
role :app, "solife.us" # This may be the same as your `Web` server
role :db, "solife.us", :primary => true


desc "Check that we can access everything"
task :check do
  on roles(:all) do |host|
    if test("[ -w #{fetch(:deploy_to)} ]")
      info "#{fetch(:deploy_to)} is writable on #{host}"
    else
      error "#{fetch(:deploy_to)} is [not] writable on #{host}"
    end
  end
end

task :my_deploy do
  on roles(:all) do |host|
    #execute("ls #{fetch(:deploy_to)}")
    cmds = ["git reset --hard HEAD"]
    cmds << "git pull origin master"
    cmds << "bundle install"
    cmds << "/bin/sh unicorn.sh restart"
    cmds.each do |cmd|
      execute "cd %s && %s" % [fetch(:deploy_to), cmd]
    end
  end
end

namespace :deploy do

    desc "show remote hostname"
    task :hostname  do
        run "hostname"
    end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      run "/bin/sh unicorn.sh restart"
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
