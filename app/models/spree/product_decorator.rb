Spree::Product.class_eval do

  def self.like_any(fields, values)
    variants = Spree::Variant.arel_table
    properties = Spree::ProductProperty.arel_table
    joins(:properties).where(fields.map { |field|
      values.map { |value|
        arel_table[field].matches("%#{value}%").
            or(variants[:sku].matches("%#{value}%")).
              or(properties[:value].matches("%#{value}%"))
      }.inject(:or)
    }.inject(:or))
  end

  def slug_candidates
    [
        trans_name,
        trans_name + [:brand, :sku]
    ]
  end


  private

  def trans_name
    result = [Translit.convert(self.name, :english)]
  end


end
