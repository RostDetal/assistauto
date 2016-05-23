module Spree

  Image.class_eval do
    has_attached_file :attachment,
                      styles: { mini: '48x48>', small: '100x100>', product: '240x240>', large: '600x600>' },
                      default_style: :product,
                      url: '/system/products/:id/:style/:basename.:extension',
                      path: ':rails_root/public/system/products/:id/:style/:basename.:extension',
                      convert_options: { all: '-strip -auto-orient -colorspace sRGB' }
    validates_attachment :attachment,
                         :presence => true,
                         :content_type => { :content_type => %w(image/jpeg image/jpg image/png image/gif) }

    after_post_process :find_dimensions

  end

end