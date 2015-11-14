module Spree
  module Admin
    OrdersController.class_eval do
      include DeliveryTimeControllerHelper

      before_action :load_order, only: [:pickup, :dropoff, :edit]
      before_action :clean_delivery_time_params, only: [:pickup, :dropoff]
      before_action :set_delivery_times, only: [:edit]

      def pickup
<<<<<<< HEAD
        @order.update_attributes(pickup: pickup_params[:pickup])
        render json: @order
      end

      def dropoff
        @order.update_attributes(dropoff: pickup_params[:dropoff])
=======
        @order.update_attributes(pickup: pickup_params[:data])
>>>>>>> bac8a9097df6ecfd65c7df68445ebe13de739cf9
        render json: @order
      end

      private

      def pickup_params
        params.require(:order).permit(:pickup, :dropoff)
      end

      def load_order
        @order ||= Spree::Order.find_by_number(params[:id])
      end
    end
  end
end