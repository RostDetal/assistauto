class AddOemNumberAndApplicabilityToSpreeProducts < ActiveRecord::Migration
  def up
    if table_exists? :spree_products
      add_column :spree_products , :oem_number, :string
      add_column :spree_products , :applicability, :string
    end
  end

  def down
    if table_exists? :spree_products
      if column_exists? :spree_products , :applicability
        remove_column  :spree_products , :applicability, :string
      end
      if column_exists? :spree_products , :oem_number
        remove_column  :spree_products , :oem_number, :string
      end
    end
  end
end
