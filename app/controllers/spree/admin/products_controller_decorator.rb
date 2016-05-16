Spree::Admin::ProductsController.class_eval do
  require 'json'


  def index
    @partners = Spree::Partner.all.uniq
    @taxons = Spree::Taxon.all.uniq
  end

  def import_price
    spreadsheet = open_spreadsheet(params[:file])
    (5..spreadsheet.last_row).each do |i|

      name = spreadsheet.cell(i, 'B').to_s #Наименование
      sku = spreadsheet.cell(i, 'C').to_s #Артикул
      brand = spreadsheet.cell(i, 'D').to_s #Изготовитель
      oem_number = spreadsheet.cell(i, 'E').to_s #Оригинальный номер
      applicability = spreadsheet.cell(i, 'F').to_s #Применяемость


      if(sku.length>0)
        if sku.include? '.0'
          sku.slice! ".0"
        end
        temp = sku.delete(' ').delete('-').delete('.').delete('/')
        sku = temp
      end

      add_product_from_price(name, sku, brand, oem_number, applicability)
    end

    redirect_to action: :index
  end

  def add_product_from_price(name, sku, brand, oem, applicability)
    params[:product] = {}
    params[:product][:available_on] ||= Time.now
    params[:product][:name] = name
    params[:product][:description] = name
    params[:product][:meta_description] = name
    params[:product][:meta_keywords] = name
    params[:product][:price] = 0
    params[:product][:sku] = sku
    params[:product][:brand] = brand
    params[:product][:applicability] = applicability
    params[:product][:shipping_category_id] = Spree::ShippingCategory.first.id

    params[:product][:product_properties_attributes] = []
    params[:product][:product_properties_attributes] << {:property_name => I18n.t('global.brand'),          :value=>brand,:position=>1}
    params[:product][:product_properties_attributes] << {:property_name => I18n.t('global.originalNumber'), :value=>oem,:position=>2}
    params[:product][:product_properties_attributes] << {:property_name => I18n.t('global.applicability'), :value=>applicability,:position=>3}

    @product = Spree::Core::Importer::Product.new(nil, product_params, {}).create

  end

  def open_spreadsheet(file)

    puts file
    case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
      when ".xls" then Roo::Excel.new(file.path, {})
      when ".xlsx" then Roo::Excelx.new(file.path, {})
      else raise "Unknown file type: #{file.original_filename}"
    end
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
      flash[:error] = "Не получилось получить экземпляр товара после всех фильтраций!"
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
    searchable_brand = params[:product][:brand]
    url = "#{partner.url}#{pattern}userlogin=#{partner.login}&userpsw=#{partner.pass}&number=#{searchable_sku}&brand=#{searchable_brand}"
  end

  def partner
    partner = Spree::Partner.find_by_id(params[:product][:partner_id])
  end

  def correct_sku
    sku = params[:product][:sku].delete(' ').delete('-').delete('.').delete('/')
  end


  def add_partner_product
    params[:product][:available_on] ||= Time.now
    params[:product][:name] = @filtered_stock[0]['description']
    params[:product][:description] = @filtered_stock[0]['description']
    params[:product][:meta_description] = @filtered_stock[0]['description']
    params[:product][:meta_keywords] = @filtered_stock[0]['description']
    params[:product][:price] = @filtered_stock[0]['price']
    params[:product][:sku] = @filtered_stock[0]['numberFix']
    params[:product][:weight] = @filtered_stock[0]['weight']
    params[:product][:shipping_category_id] = Spree::ShippingCategory.first.id

    params[:product][:product_properties_attributes] = []
    params[:product][:product_properties_attributes] << {:property_name => I18n.t('global.brand'),          :value=>@filtered_stock[0]['brand'],:position=>1}
    params[:product][:product_properties_attributes] << {:property_name => I18n.t('global.originalNumber'), :value=>params[:product][:oem_number],:position=>2}
    params[:product][:product_properties_attributes] << {:property_name => I18n.t('global.applicability'), :value=>params[:product][:applicability],:position=>3}
    params[:product][:product_properties_attributes] << {:property_name => I18n.t('global.weight'),         :value=>@filtered_stock[0]['weight'],:position=>4}
    # params[:product][:product_properties_attributes] << {:property_name => I18n.t('global.deliveryPeriod'), :value=>get_days(@filtered_stock[0]['deliveryPeriod']),:position=>5}
    params[:product][:product_properties_attributes] << {:property_name => I18n.t('global.status'),         :value=>I18n.t('global.can_return', :count=>@filtered_stock[0]['noReturn']),:position=>4}



    puts permitted_product_attributes

    @product = Spree::Core::Importer::Product.new(nil, product_params, {}).create

    if @product.persisted?
      flash[:success] = "Товар успешно создан"
    else
      flash[:error] = "Товар не создан. Есть такой код товара и он уже создан!"
    end

  end

  def get_days(hours)
    hours = hours/24
    response = I18n.t('global.delivery_days', :count => hours)
  end

  def get_return_state
    state
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
