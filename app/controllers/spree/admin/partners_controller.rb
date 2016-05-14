module Spree
  module Admin
    class PartnersController < ResourceController
      def collection
        super.order(:name)
      end
    end
  end
end

