app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}"



rails_env = ENV['RAILS_ENV'] || "production"
environment rails_env

if rails_env!="development"
  threads 2, 16
  workers 4

  daemonize true
  bind "unix://#{shared_dir}/tmp/sockets/puma.sock"
  pidfile "#{shared_dir}/tmp/pids/puma.pid"
  state_path "#{shared_dir}/tmp/pids/puma.state"
  activate_control_app "#{shared_dir}/tmp/sockets/pumactl.sock"
  stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true

  preload_app!





end