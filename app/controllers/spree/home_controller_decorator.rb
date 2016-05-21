Spree::HomeController.class_eval do
  def index
    @searcher = build_searcher(params.merge(include_images: true))
    @products = @searcher.retrieve_products.includes(:possible_promotions)
    @taxonomies = Spree::Taxonomy.includes(root: :children).where(:can_show_home => true)
  end

end
