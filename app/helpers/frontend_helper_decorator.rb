Spree::FrontendHelper.class_eval do
  require 'digest/md5'
  def checkpartner__price(sku)
    HTTP.get(Spree::Config[:voshod_api_url]+"search/articles?userlogin="+Spree::Config[:voshod_api_login]+"&userpsw="+Digest::MD5.hexdigest(Spree::Config[:voshod_api_pass])+"&number="+sku+"&brand=AMTEL")
  end

end

