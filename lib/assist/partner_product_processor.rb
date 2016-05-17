module Assist
  class PartnerProductProcessor

    require 'json'

    class << self
      include Spree::Core::Engine.routes.url_helpers
    end

      def import

      end

      def self.get_price(product)
        if product.price === 0 || Time.now >= product.updated_at + 1.day
          @product = product
          @partner = Spree::Partner.find_by_id(product.partner_id)
          @brand = @product.brand
          @sku = @product.sku
          @response = get_product_data

          if @response.length > 0
            update_product(@response)
          end
        end
      end



    private

    def self.update_product(response)
      params = {}

      params[:available_on] ||= Time.now
      params[:name] = response[0]['description']
      params[:description] = response[0]['description']
      params[:meta_description] = response[0]['description']
      params[:meta_keywords] = response[0]['description']
      params[:price] = response[0]['price']
      params[:sku] = response[0]['numberFix']
      params[:weight] = response[0]['weight']

      @product.update_attributes(params)
    end

    def self.get_product_data
      response = HTTParty.get(search_articles_url)

      if response.success?
        # puts "Product found!"
      else
        # flash[:error] = "Не удалось получить данные по товару. Попробуйте еще!"
      end

      @json = JSON.parse(response.body)
      @filter_all = @json.select{|hash| hash['numberFix'] == clear_sku && hash['brand'].downcase == @brand.downcase}
      @filter_partner_stock = @filter_all.select{|hash| hash['distributorId'] == @partner.stock}
      @filter_main_stock = @filter_all.select{|hash| hash['distributorId'] == @partner.main_stock}

      @filtered_stock = @filter_partner_stock.length>0 ? @filter_partner_stock : @filter_main_stock.length > 0 ? @filter_main_stock : @filter_all
    end

    def self.search_articles_url
      pattern = "/search/articles?"
      url = "#{@partner.url}#{pattern}userlogin=#{@partner.login}&userpsw=#{@partner.pass}&number=#{clear_sku}&brand=#{@brand}"
    end

    def self.clear_sku
      cleared_sku = @sku.delete(' ').delete('-').delete('.').delete('/')
    end



  end
end