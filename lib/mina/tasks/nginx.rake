namespace :nginx do
  desc "update site config"
  task :update_site_config => :environment do
      local_conf = "#{deploy_to}/current/config/nginx/#{rails_env}.conf"
      nginx_avail_site_conf = "/etc/nginx/sites-available/#{application}_#{rails_env}.conf"
      nginx_enabled_site_conf = "/etc/nginx/sites-enabled/#{application}_#{rails_env}.conf"
      queue %[echo "-----> Copуing nginx conf files"]
      queue %[sudo cp -f #{local_conf} #{nginx_avail_site_conf}]
      queue %[sudo ln -nfs #{nginx_avail_site_conf} #{nginx_enabled_site_conf}]
      queue %[echo "-----> Copуing nginx conf files done"]
  end

  desc "reload nginx"
  task :reload => :environment do
      queue %[sudo service nginx reload]
      queue %[echo "Reloading NGINX done"]
  end

  desc "restart nginx"
  task :restart => :environment do

      queue %[sudo service nginx restart]
      queue %[echo "Restarting NGINX done"]
  end

  desc "stop nginx"
  task :stop => :environment do
      queue %[sudo service nginx stop]
      queue %[echo "Stopping NGINX done"]
  end

  desc "start nginx"
  task :start => :environment do
      queue %[sudo service nginx start]
      queue %[echo "Starting NGINX done"]
  end

  desc "Check nginx status"
  task :status => :environment do
      queue %[sudo service nginx status]
  end
end