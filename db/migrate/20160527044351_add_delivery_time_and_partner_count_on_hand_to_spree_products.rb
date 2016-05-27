class AddDeliveryTimeAndPartnerCountOnHandToSpreeProducts < ActiveRecord::Migration
  def up
    add_column :spree_products, :delivery_time, :integer, default: 0
    add_column :spree_products, :partner_count, :integer, default: 0
  end

  def down
   remove_column :spree_products, :delivery_time, :integer
   remove_column :spree_products, :partner_count, :integer
  end
end
