Spree::ProductsController.class_eval do
  before_action :try_update_product, only: :show


  def show
    @variants = @product.variants_including_master.active(current_currency).includes([:option_values, :images])
    @product_properties = @product.product_properties.includes(:property)
    @taxon = Spree::Taxon.find(params[:taxon_id]) if params[:taxon_id]

    redirect_if_legacy_path
  end

  private

  def try_update_product
    Assist::PartnerProductProcessor.get_price(@product)
  end

end
