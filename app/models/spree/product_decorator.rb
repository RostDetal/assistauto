Spree::Product.class_eval do


  def slug_candidates
    [
        [trans_name, :id]
    ]
  end

  def trans_name
   name = Translit.convert(self.name, :english)
  end
end
