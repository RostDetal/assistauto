Spree::FrontendHelper.class_eval do
  require 'digest/md5'

  def check_price(sku)
    request = url+"/search/articles?userlogin="+lgn+"&userpsw="+psw+"&number="+sku+"&brand=AMTEL"
    response = HTTParty.get(request).to_json
  end

  private
  def lgn
    login = Spree::Config[:voshod_api_login]
  end
  def psw
    psw = Digest::MD5.hexdigest(Spree::Config[:voshod_api_pass])
  end
  def url
    Spree::Config[:voshod_api_url]
  end



end

