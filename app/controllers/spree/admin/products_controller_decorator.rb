Spree::Admin::ProductsController.class_eval do
  require 'json'


  def index
    @partners = Spree::Partner.all.uniq
    @taxons = Spree::Taxon.all.uniq
  end

  # Импорт прайсов
  def import_price
    Assist::PartnerProductProcessor.import(params)
    redirect_to action: :index
  end

  def create_product_partner
    if Assist::PartnerProductProcessor.add_single(params)
      flash[:success] = "Товар создан успешно!"
    else
      flash[:error] = "Ошибка в создании товара!"
    end
    redirect_to action: :index
  end

end
