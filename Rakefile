#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'sshkit/dsl'
require 'highline/import'

Wtf::Application.load_tasks

SSHKit.config.command_map[:bundle] = "/.rbenv/shims/bundle"
SSHKit.config.command_map[:rake] = "/.rbenv/shims/rake"

host = "web.ad.sofse.org"

task :deploy do
  user = ask("Enter username for #{host}:")
  on %W{#{user}@#{host}} do
    within "/web" do
      with rails_env: 'production' do
        execute :git, 'pull'
        execute 'bundle', '--without development:test', 'install'      
        rake 'db:migrate'     
        rake 'assets:precompile'     
        rake 'server:start'
      end
    end
  end
end
  
namespace :server do

  task :start do
    if File.exists?(Rails.root.join('tmp/pids/unicorn.pid'))
      pid = File.read(Rails.root.join('tmp/pids/unicorn.pid')).to_i
      Process.kill("HUP", pid)
      puts 'Restarted the server'
    else
      puts 'Not running, starting the server...'
      sh 'bundle exec unicorn -c config/unicorn.rb -E production -D'
    end
  end

  task :stop do
    if File.exists?(Rails.root.join('tmp/pids/unicorn.pid'))
      pid = File.read(Rails.root.join('tmp/pids/unicorn.pid')).to_i
      Process.kill("QUIT", pid)
      puts 'Stopped the server'
    else
      puts 'Server already down'
    end
  end

end

task :test do
  # Rake::Task['db:drop'].execute
  # Rake::Task['db:create'].execute
  Rake::Task['db:migrate'].execute
  Rake::Task['spec'].execute
  # Rake::Task['cucumber:all'].execute
end
