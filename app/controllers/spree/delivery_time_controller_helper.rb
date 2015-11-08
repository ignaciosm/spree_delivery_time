module Spree
  # module Admin
  module DeliveryTimeControllerHelper
    def clean_delivery_time_params
      pickup_time = params["order"].try(:delete, :pickup_time)
      pickup_date = params["order"].try(:delete, :pickup_date)
      dropoff_time = params["order"].try(:delete, :dropoff_time)
      dropoff_date = params["order"].try(:delete, :dropoff_date)
      params["order"][:pickup] = Time.zone.parse("#{pickup_date} #{pickup_time}").to_s unless (pickup_time.nil? || pickup_date.nil?)
      params["order"][:dropoff] = Time.zone.parse("#{dropoff_date} #{dropoff_time}").to_s unless (dropoff_time.nil? || dropoff_date.nil?)
    end

    def set_delivery_times
      set_time_zone
      if @order.pickup && @order.dropoff
        set_selected_pickup_times
        set_selected_dropoff_times
      end
      set_soonest_pickup_date
      set_soonest_dropoff_date
      set_valid_pickup_dropoff_times
      set_latest_pickup_date
      set_latest_dropoff_date
    end

    def set_selected_pickup_times
      current_set_pickup_time = Time.zone.parse(@order.pickup.to_s)
      @selected_pickup_date = current_set_pickup_time.strftime('%Y-%m-%d')
      @selected_pickup_date_utc = current_set_pickup_time.utc.strftime('%Y-%m-%d')
      @selected_pickup_time = current_set_pickup_time.strftime('%T')
    end

    def set_selected_dropoff_times
      current_set_dropoff_time = Time.zone.parse(@order.dropoff.to_s)
      @selected_dropoff_date = current_set_dropoff_time.strftime('%Y-%m-%d')
      @selected_dropoff_date_utc = current_set_dropoff_time.utc.strftime('%Y-%m-%d')
      @selected_dropoff_time = current_set_dropoff_time.strftime('%T')
    end

    def set_valid_pickup_dropoff_times
      @valid_times = (time_open.hour..time_close.hour).to_a.map{ |hour| Time.zone.parse("#{hour}:00:00").strftime('%T') }
    end

    def set_soonest_pickup_date
      @soonest_pickup ||= Time.zone.now + min_hours_from_order_to_pickup.hours
      if @soonest_pickup > time_close && @soonest_pickup < (time_open + 1.day)
        @soonest_pickup = time_open + 1.day
      end
      @soonest_pickup_date ||= @soonest_pickup.strftime('%Y-%m-%d')
      @soonest_pickup_date_utc ||= @soonest_pickup.utc.strftime('%Y-%m-%d')
      @soonest_pickup
    end

    def set_latest_pickup_date
      @latest_pickup ||= set_soonest_pickup_date + max_days_to_pickup.days
      @latest_pickup_date ||= @latest_pickup.strftime('%Y-%m-%d')
      @latest_pickup
    end

    def set_soonest_dropoff_date
      @soonest_dropoff ||= set_soonest_pickup_date + min_hours_from_pickup_to_delivery.hours
      @soonest_dropoff_date ||= @soonest_dropoff.strftime('%Y-%m-%d')
      @soonest_dropoff_date_utc ||= @soonest_dropoff.utc.strftime('%Y-%m-%d')
      @soonest_dropoff
    end

    def set_latest_dropoff_date
      @latest_dropoff ||= set_latest_pickup_date + max_days_to_delivery
      @latest_dropoff_date ||= @latest_dropoff.strftime('%Y-%m-%d')
      @latest_dropoff
    end

    def set_time_zone
      Time.zone = SpreeDeliveryTime::Config::TIME_ZONE
    end

    # TODO: Extract these into a helper module
    def time_open
      @time_open ||= Time.zone.parse(SpreeDeliveryTime::Config::TIME_OPEN)
    end
    
    def time_close
      @time_close ||= Time.zone.parse(SpreeDeliveryTime::Config::TIME_CLOSE)
    end

    def min_hours_from_order_to_pickup
      @min_hours_from_order_to_pickup ||= SpreeDeliveryTime::Config::HOURS_FROM_ORDER_TO_PICKUP.to_i
    end

    def min_hours_from_pickup_to_delivery
      @min_hours_from_pickup_to_delivery ||= SpreeDeliveryTime::Config::HOURS_FROM_PICKUP_TO_DELIVERY.to_i
    end

    def max_days_to_pickup
      @max_days_to_pickup ||= SpreeDeliveryTime::Config::MAX_DAYS_TO_PICKUP.to_i
    end

    def max_days_to_delivery
      @max_days_to_delivery ||= SpreeDeliveryTime::Config::MAX_DAYS_TO_DELIVERY.to_i
    end
  end
  # end
end