class AddShowOnMainPageFieldToSpreeTaxonomies < ActiveRecord::Migration
  def up
    if table_exists? :spree_taxons
      add_column :spree_taxons , :can_show, :boolean, :default => false
    end

    if table_exists? :spree_taxonomies
      add_column :spree_taxonomies , :can_show_home, :boolean, :default => false
    end
  end

  def down
    if table_exists? :spree_taxons
      if column_exists? :spree_taxons , :can_show
        remove_column :spree_taxons , :can_show, :boolean
      end
    end
    if table_exists? :spree_taxonomies
      if column_exists? :spree_taxonomies , :can_show_home
        remove_column :spree_taxonomies , :can_show_home, :boolean
      end
    end
  end
end
