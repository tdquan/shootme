
cap_path = "/home/shootme/staging"
app_path = "#{cap_path}/current"

worker_processes 2
timeout 30

working_directory app_path

pid "#{cap_path}/shared/pids/unicorn.pid"

listen "#{cap_path}/shared/sockets/unicorn.socket", :backlog => 64

stderr_path "#{cap_path}/shared/log/unicorn.stderr.log"
stdout_path "#{cap_path}/shared/log/unicorn.stdout.log"

before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{app_path}/Gemfile"
end

preload_app true

before_fork do |server, worker|
  # needed if preload_app
  ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base)
  server.logger.info("worker=#{worker.nr} spawning in #{Dir.pwd}")

  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT. Using this method we get 0 downtime deploys.
  old_pid_file = "#{cap_path}/shared/pids/unicorn.pid.oldbin"
  if File.exists?(old_pid_file) && server.pid != old_pid_file
    begin
      old_pid = File.read(old_pid_file).to_i
      server.logger.info("sending QUIT to #{old_pid}")
      Process.kill("QUIT", old_pid)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  # needed if preload_app
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)

end
