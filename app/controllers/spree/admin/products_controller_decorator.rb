Spree::Admin::ProductsController.class_eval do
  require 'json'

  def index
    @partners = Spree::Partner.all.uniq
    @taxons = Spree::Taxon.all.uniq
  end


  def create_product_partner
    @response = get_product_info

    if @response.success?
      puts "Product found!"
    else
      flash[:error] = "Не удалось получить данные по товару. Попробуйте еще!"
    end

    @json = JSON.parse(@response.body)
    @filter_all = @json.select{|hash| hash['numberFix'] == correct_sku && hash['brand'].downcase == params[:product][:brand].downcase}
    @filter_partner_stock = @filter_all.select{|hash| hash['distributorId'] == partner.stock}
    @filter_main_stock = @filter_all.select{|hash| hash['distributorId'] == partner.main_stock}

    @filtered_stock = @filter_partner_stock.length>0 ? @filter_partner_stock : @filter_main_stock.length > 0 ? @filter_main_stock : @filter_all

    puts @filter_all

    if @filter_all.length == 0
      flash[:error] = "После фильтрации не найдено ни одного товара по указанному бренду и коду товара!"
    end

    if @filtered_stock.length > 0
      add_partner_product
    else
      flash[:error] = "После фильтрации складов не найдено ни одного товара!"
    end

    redirect_to action: :index
  end


  private
  def get_product_info
    response = HTTParty.get(get_product_info_url)
  end

  def get_product_info_url
    pattern = "/search/articles?"
    searchable_sku = correct_sku

    puts "SKU: "+searchable_sku

    searchable_brand = params[:product][:brand]
    url = "#{partner.url}#{pattern}userlogin=#{partner.login}&userpsw=#{partner.pass}&number=#{searchable_sku}&brand=#{searchable_brand}"
  end

  def partner
    partner = Spree::Partner.find_by_id(params[:product][:partner_id])
  end

  def correct_sku
    sku = params[:product][:sku].delete(' ').delete('-').delete('.')
  end


  def add_partner_product
    params[:product][:available_on] ||= Time.now
    params[:product][:name] = @filtered_stock[0]['description']
    params[:product][:meta_description] = @filtered_stock[0]['description']
    params[:product][:meta_keywords] = @filtered_stock[0]['description']
    params[:product][:price] = @filtered_stock[0]['price']
    params[:product][:sku] = @filtered_stock[0]['numberFix']
    params[:product][:weight] = @filtered_stock[0]['weight']
    params[:product][:shipping_category_id] = Spree::ShippingCategory.first.id
    @product = Spree::Core::Importer::Product.new(nil, product_params, {}).create

    if @product.persisted?
      flash[:success] = "Товар успешно создан"
    else
      flash[:error] = "Товар не создан. Есть такой код товара и он уже создан!"
    end

  end



  def product_params
    params.require(:product).permit(permitted_product_attributes)
  end

  def variants_params
    variants_key = if params[:product].has_key? :variants
                     :variants
                   else
                     :variants_attributes
                   end

    params.require(:product).permit(
        variants_key => [permitted_variant_attributes, :id],
    ).delete(variants_key) || []
  end


end
