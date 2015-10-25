module Spree
  module Admin
    OrdersController.class_eval do
      include Spree::Admin::DeliveryTimeControllerHelper

      before_action :load_order, only: [:pickup, :edit]
      before_action :set_delivery_times, only: [:edit]

      def pickup
        raise
        @order.update_attributes(pickup: pickup_params[:data])
        # render json: {'hello' => 'there'}
        # render json: {'params' => "#{pickup_params[:data]}"}
        render json: @order
      end

      private

      def load_order
        @order ||= Spree::Order.find_by_number(params[:id])
      end
    end
  end
end