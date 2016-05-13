Spree::ProductsController.class_eval do
  def show
    @variants = @product.variants_including_master.active(current_currency).includes([:option_values, :images])
    @product_properties = @product.product_properties.includes(:property)
    @taxon = Spree::Taxon.find(params[:taxon_id]) if params[:taxon_id]
    @data = check_price (@product.sku)
    redirect_if_legacy_path
  end

  private

  def check_price(sku)

    begin
      request = url+"/search/articles?userlogin="+lgn+"&userpsw="+psw+"&number="+sku+"&brand=AMTEL"
      response = HTTParty.get(request).to_json
    rescue
      request = {}
    end



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
