Spree::ProductsHelper.class_eval do
  def product_name(product)
    name = product.name + ' ('+product.sku+', '+product.brand+')'
  end

  def product_price

  end

  def can_buy(product)
    product.price != 0
  end

end