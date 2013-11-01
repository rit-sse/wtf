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

  # let's run the workers as the deploy user instead of as root
  # begin
  #   uid, gid = Process.euid, Process.egid
  #   user, group = 'deploy', 'deploy'
  #   target_uid = Etc.getpwnam(user).uid
  #   target_gid = Etc.getgrnam(group).gid
  #   worker.tmp.chown(target_uid, target_gid)
  #   if uid != target_uid || gid != target_gid
  #     Process.initgroups(user, target_gid)
  #     Process::GID.change_privilege(target_gid)
  #     Process::UID.change_privilege(target_uid)
  #   end
  # rescue => e
  #   STDERR.puts "couldn't change user, oh well"
  #   raise e
  # end
end
