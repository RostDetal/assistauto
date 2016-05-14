module Spree
  class Partner < Spree::Base

    def partner_name
      "#{name}"
    end

  end
end