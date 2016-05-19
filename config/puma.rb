app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}"

directory app_dir

rails_env = ENV['RAILS_ENV'] || "production"
environment rails_env

if rails_env!="development"
  pidfile "#{shared_dir}/tmp/pids/puma.pid"
  stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true
  state_path "#{shared_dir}/tmp/pids/puma.state"
  activate_control_app "#{shared_dir}/tmp/sockets/pumactl.sock"

  threads 2, 16
  workers 4

  bind "unix://#{shared_dir}/tmp/sockets/puma.sock"
  daemonize true
end