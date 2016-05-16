Spree::Product.class_eval do

  def self.like_any(fields, values)
    variants = Spree::Variant.arel_table
    where fields.map { |field|
      values.map { |value|
        arel_table[field].matches("%#{value}%").
            or(variants[:sku].matches("%#{value}%"))
      }.inject(:or)
    }.inject(:or)
  end

  def slug_candidates
    [
        [trans_name, :brand]
    ]
  end


  def trans_name
   name = Translit.convert(self.name, :english)
  end
end
