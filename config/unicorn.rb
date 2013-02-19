module Rails
  class <<self
    def root
      File.expand_path(__FILE__).split('/')[0..-3].join('/')
    end
  end
end

preload_app true
working_directory Rails.root
pid "#{Rails.root}/tmp/pids/unicorn.pid"
stderr_path "#{Rails.root}/log/unicorn.log"
stdout_path "#{Rails.root}/log/unicorn.log"

listen 8080, :tcp_nopush => false

listen "/tmp/unicorn.mystory.sock"
worker_processes 6
timeout 120

if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

before_fork do |server, worker|
  old_pid = "#{Rails.root}/tmp/pids/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      puts "Send 'QUIT' signal to unicorn error!"
    end
  end
end

#Resove the problem: PGError: ERROR:  prepared statement "a3" already exists.But do this may raise exception.Fix it:https://github.com/kennyj/rails/commit/b40b7f459e3ea66f824ac4791d8882775b4f6717
after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end