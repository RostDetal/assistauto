module Spree
  class Partner < Spree::Base
    require 'digest/md5'


    def partner_name
      "#{name}"
    end

    def url
      return self.api_url
    end

    def stock
      self.partner_stock_id
    end

    def main_stock
      self.base_stock_id
    end

    def login
      self.api_login
    end

    def pass
      Digest::MD5.hexdigest(self.api_pass)
    end

  end
end