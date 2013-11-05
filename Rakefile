#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'sshkit/dsl'
require 'highline/import'

Wtf::Application.load_tasks

task :deploy do |t, args|
  user = ask('Enter username:')
  on %W{#{user}@web.ad.sofse.org} do
    within "/web" do
      with rails_env: :production do
        execute :git, 'pull origin staging'
        # execute :bundle, '--without development:test','install'
        # rake 'db:migrate assets:precompile'        
        if File.exists?('/web/tmp/pids/unicorn.pid')
          pid = File.open('/web/tmp/pids/unicorn.pid').read.to_i
          Process.kill("HUP", pid)
          puts 'Restarted the server'
        else
          puts 'Not running'
          # execute :unicorn, '-c config/unicorn.rb'
        end
      end
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

