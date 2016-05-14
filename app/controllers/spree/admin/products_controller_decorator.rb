Spree::Admin::ProductsController.class_eval do

  def index
    @partners = Spree::Partner.all.uniq
    @taxons = Spree::Taxon.all.uniq
  end

  def test

  end

end
