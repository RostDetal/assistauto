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
    partner = Spree::Partner.find_by_id(product.partner_id)
    analogs = Assist::PartnerProductProcessor.get_product_analog(product)
    hashMap = []

    filteredByBrand={}
    analogs.each do |analog|
      if filteredByBrand[analog["brand"]].nil?
        filteredByBrand[analog["brand"]] = []
        filteredByBrand[analog["brand"]] << analog
      else
        filteredByBrand[analog["brand"]] << analog
      end
    end


    filteredByNumber = {}
    filteredByBrand.each do |analog|
      firstElement = analog[1][0]
      analog[1].each do |item|
        if item['numberFix'] == firstElement['numberFix'] && item['deliveryPeriod'] < firstElement['deliveryPeriod'] && item['availability'] > 0
          firstElement = item
        end
      end
      filteredByNumber[analog[0]] = firstElement
    end

    filteredByNumber.each do |item|
      analog = item[1]
      price =
      hashMap <<{:distributor =>analog["distributorId"],
                                :brand =>analog["brand"],
                                :numer => analog["number"],
                                :numberFix => analog["numberFix"],
                                :price => (analog["price"] + ((analog["price"] * partner.percents)/100)).ceil,
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
