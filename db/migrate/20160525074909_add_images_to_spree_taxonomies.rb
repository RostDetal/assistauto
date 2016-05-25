class AddImagesToSpreeTaxonomies < ActiveRecord::Migration
  def up
    if table_exists? :spree_taxonomies
      add_column :spree_taxonomies , :image_file_name, :string
      add_column :spree_taxonomies , :image_content_type, :string
      add_column :spree_taxonomies , :image_file_size, :string
      add_column :spree_taxonomies , :image_updated_at, :string
    end


  end

  def down
    if table_exists? :spree_taxonomies
      if column_exists? :spree_taxonomies , :image_file_name
        remove_column :spree_taxonomies , :image_file_name, :string
      end
      if column_exists? :spree_taxonomies , :image_content_type
        remove_column :spree_taxonomies , :image_content_type, :string
      end
      if column_exists? :spree_taxonomies , :image_file_size
        remove_column :spree_taxonomies , :image_file_size, :string
      end
      if column_exists? :spree_taxonomies , :image_updated_at
        remove_column :spree_taxonomies , :image_updated_at, :string
      end
    end
  end
end
