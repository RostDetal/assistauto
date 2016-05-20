class AddAdditionalPercentsToSpreePartner < ActiveRecord::Migration
  def up
    if table_exists? :spree_partners
      add_column :spree_partners , :percents, :number
    end
  end

  def down
    if table_exists? :spree_products
      if column_exists? :spree_partners , :percents
        remove_column  :spree_partners , :percents, :number
      end
    end
  end
end
