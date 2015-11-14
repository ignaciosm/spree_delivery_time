module Spree
  CheckoutController.class_eval do
    include DeliveryTimeControllerHelper

    before_action :permit_new_attributes
    before_action :clean_delivery_time_params
    before_action :set_delivery_times

     def update
      raise
      if @order.update_from_params(params, @new_permitted_checkout_attributes, request.headers.env)
        @order.temporary_address = !params[:save_user_address]
        unless @order.next
          flash[:error] = @order.errors.full_messages.join("\n")
          redirect_to(checkout_state_path(@order.state)) && return
        end

        if @order.completed?
          @current_order = nil
          flash.notice = Spree.t(:order_processed_successfully)
          flash['order_completed'] = true
          redirect_to completion_route
        else
          redirect_to checkout_state_path(@order.state)
        end
      else
        render :edit
      end
    end

    def permit_new_attributes
      byebug
      @new_permitted_checkout_attributes = permitted_checkout_attributes + [:pickup, :dropoff]
    end
  end
end
