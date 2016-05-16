class AddDataFieldsToSpreeProduct < ActiveRecord::Migration
  def up
    if table_exists? :spree_products
      add_column :spree_products , :partner_id, :integer
      add_column :spree_products , :brand, :string
    end
  end

  def down
    if table_exists? :spree_products
      if column_exists? :spree_products , :partner_id
        remove_column  :spree_products , :partner_id, :integer
      end
      if column_exists? :spree_products , :brand
        remove_column  :spree_products , :brand, :string
      end
    end
  end
end
