APP_ROOT = File.expand_path(File.dirname(File.dirname(__FILE__)))

ENV['BUNDLE_GEMFILE'] = File.expand_path('../Gemfile', File.dirname(__FILE__))
require 'bundler/setup'

worker_processes 3
working_directory APP_ROOT

preload_app true

timeout 30

listen "#{APP_ROOT}/tmp/sockets/unicorn.sock", backlog: 64
listen 1234, :tcp_nopush => false # Make the sock file nginx is looking for but with out handling request

pid "#{APP_ROOT}/tmp/pids/unicorn.pid"

stderr_path "#{APP_ROOT}/log/unicorn.stderr.log"
stdout_path "#{APP_ROOT}/log/unicorn.stdout.log"

before_fork do |server, worker|
  old_pid = "#{APP_ROOT}/tmp/pids/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  # if preload_app is true, then you may also want to check and
  # restart any other shared sockets/descriptors such as Memcached,
  # and Redis.  TokyoCabinet file handles are safe to reuse
  # between any number of forked children (assuming your kernel
  # correctly implements pread()/pwrite() system calls)

  ##
  # Unicorn master loads the app then forks off workers - because of the way
  # Unix forking works, we need to make sure we aren't using any of the parent's
  # sockets, e.g. db connection

  ActiveRecord::Base.establish_connection

end
