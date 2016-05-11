module Spree
  module Admin
    class AutoserviceSettingsController< Spree::Admin::BaseController
      include Spree::Backend::Callbacks
      before_action :set_store

      def show
        render 'edit'
      end

      def edit
        @preferences_security = []
      end

      def update
        params.each do |name, value|
          next unless Spree::Config.has_preference? name
          Spree::Config[name] = value
        end

        current_store.update_attributes store_params

        flash[:success] = Spree.t(:successfully_updated, resource: Spree.t(:general_settings))
        redirect_to edit_admin_autoservice_settings_path
      end

      private
      def store_params
        params.permit(permitted_store_attributes)
      end

      def set_store
        @store = current_store
      end
    end
  end
end

