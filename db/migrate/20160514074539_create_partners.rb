class CreatePartners < ActiveRecord::Migration
  def up

    if !table_exists?(:spree_partners)
      create_table :spree_partners do |t|
        t.string :name
        t.string :api_url
        t.string :api_login
        t.string :api_pass
        t.integer :partner_stock_id
        t.integer :base_stock_id
        t.timestamps null: false
      end
    end
  end

  def down
    if table_exists?(:spree_partners)
      drop_table :spree_partners
    end
  end
end
