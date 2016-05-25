Spree::Taxonomy.class_eval do


  has_attached_file :image,
                    styles: { mini: '32x32>', normal: '128x128>', big:'256x256>' },
                    default_style: :mini,
                    url: '/system/taxonomies/:id/:style/:basename.:extension',
                    path: ':rails_root/public/system/taxonomies/:id/:style/:basename.:extension',
                    default_url: '/assets/default_taxon.png'

  validates_attachment :image,
                       content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

end

