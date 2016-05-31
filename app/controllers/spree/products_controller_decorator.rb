Spree::ProductsController.class_eval do
  before_action :try_update_product, only: :show


  def show
    @variants = @product.variants_including_master.active(current_currency).includes([:option_values, :images])
    @product_properties = @product.product_properties.includes(:property)
    @taxon = Spree::Taxon.find(params[:taxon_id]) if params[:taxon_id]

    redirect_if_legacy_path
  end

  def analogs
    product = Spree::Product.find_by_id(params["p_id"])
    analogs = Assist::PartnerProductProcessor.get_product_analog(product)
    hashMap = []
    analogs.each do |analog|
      puts analog
      hashMap <<{:distributor =>analog["distributorId"],
                                :brand =>analog["brand"],
                                :numer => analog["number"],
                                :numberFix => analog["numberFix"],
                                :price => analog["price"],
                                :description => analog["description"],
                                :deliveryPeriod => analog["deliveryPeriod"],
                                :availability => analog["availability"]}
    end
    render :json => hashMap.to_json
  end

  private

  def try_update_product
    Assist::PartnerProductProcessor.get_product_update(@product)
  end

end
