namespace :asistes do

  desc "Checking all system"
  task :init => :environment do
    queue %[echo "                                                                                          "]
    queue %[echo "[ASSISTAUTO] Start initing tasks!"]
    queue %[echo "[ASSISTAUTO] Current release path: #{app_path}"]
    queue %[echo "[ASSISTAUTO] Environment is: #{rails_env}"]
    queue %[echo "                                                                                          "]
  end

  namespace :mail do

    desc "Send welcome template"
    task :welcome => :environment do
      queue %[echo "[MAIL] Sending welcome!"]
      Spree::DisassemblyMailer.welcome(Spree::User.first)
    end

  end

end