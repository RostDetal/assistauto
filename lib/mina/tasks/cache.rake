namespace :cache do

  desc "Clear cache"
  task :clear => :environment do
    # queue %[cd #{app_path} && RAILS_ENV=#{rails_env} bundle exec rake tmp:cache:clear]
    # queue %[cd #{app_path} && RAILS_ENV=#{rails_env} bundle exec rake assets:clean]
    queue "cd #{app_path} && RAILS_ENV=#{rails_env} && bin/cleanup.sh start"
    queue %[echo "cache cleared"]
  end

end
