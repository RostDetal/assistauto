Spree::Price.class_eval do

  def price_including_vat_for(price_options)
    options = price_options.merge(tax_category: variant.tax_category)
    new_price = price + (price * (get_partner_percents/100))
    gross_amount(new_price, options)
  end

  def display_price_including_vat_for(price_options)
    Spree::Money.new(price_including_vat_for(price_options), currency: currency)
  end

  private

  def get_partner_percents
    partner_id = Spree::Product.find_by_id(variant.product_id).partner_id
    partner = Spree::Partner.find_by_id(partner_id)
    percents = partner.nil? ? 0 : partner.percents
    percents
  end

end
