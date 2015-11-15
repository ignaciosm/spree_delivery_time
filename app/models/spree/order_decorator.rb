# Spree::Order.state_machine.before_transition :to => :payment, :do => :delivery_time_provided?

module Spree
  Order.class_eval do
    include DeliveryTimeControllerHelper

    validate :delivery_time

    def time_high(time_sym)
      return unless [:pickup, :dropoff].include?(time_sym)
      (send(time_sym) + 1.hour).strftime("%H:%M")
    end

    def time_low(time_sym)
      return unless [:pickup, :dropoff].include?(time_sym)
      send(time_sym).strftime("%H:%M")
    end

    def date_str(time_sym)
      return unless [:pickup, :dropoff].include?(time_sym)
      send(time_sym).strftime("%a, %d %b %Y")
    end

    def date(time_sym)
      return unless [:pickup, :dropoff].include?(time_sym)
      send(time_sym).strftime("%Y-%m-%d")
    end

    def time(time_sym)
      return unless [:pickup, :dropoff].include?(time_sym)
      send(time_sym).strftime("%H:%M:%S")
    end

    def delivery_time_str(time_sym)
      return unless [:pickup, :dropoff].include?(time_sym)
      return "#{date_str(time_sym)} #{time_low(time_sym)}"
    end

    private

    def delivery_time_provided?
      # Is both pickup and dropoff time present?
      if (dropoff.nil? || pickup.nil?)
        errors.add(:order, "must have pickup and dropoff time in the form of 'YYYY-MM-DD HH:MM:SS'")
        return false
      end
      true
    end

    def delivery_time
      set_time_zone
      return unless (pickup || dropoff)
      return false unless delivery_time_provided?
      # return false unless valid_time_format?([pickup, dropoff])
      return false unless valid_time_range?
    end

    # Check time string that it is in a valid format and can be parsed by Time.zone
    # def valid_time_format?(times_arr)
    #   # byebug
    #   times_arr.map(&:to_s).each do |time_str|
    #     # byebug
    #     if (time_str =~ /\A\d{4}-\d{1,2}-\d{1,2} \d{1,2}:\d{1,2}(:\d{1,2})? (-?\+?\d{4})?$/).nil?
    #       errors.add(:order, "must have pickup and dropoff time in the form of 'YYYY-MM-DD HH:MM:SS'")
    #       return false
    #     end

    #     begin
    #       Time.zone.parse(time_str)
    #     rescue ArgumentError => e
    #       errors.add(:delivery_time, 'must be a valid time and date')
    #       return false
    #     end
    #   end
    # end

    # Check that the pickup time and delivery time are in a valid range
    def valid_time_range?
      # Is pickup time later than dropoff time?
      if pickup > dropoff
        errors.add(:pickup_time, 'must be earlier than dropoff time')
        return false
      # Is pickup and dropoff time during operating hours?
      elsif (!pickup.hour.between?(time_open.hour, time_close.hour) || !dropoff.hour.between?(time_open.hour, time_close.hour))
        errors.add(:delivery_time, "must be during our business hours: #{time_open.strftime('%T')} - #{time_close.strftime('%T')}")
        return false
      # Is dropoff time at least min necessary hours from pickup time?
      elsif (dropoff < (pickup + min_hours_from_pickup_to_delivery.hour))
        errors.add(:dropoff_time, "must be at least #{min_hours_from_pickup_to_delivery} hours from pickup time.")
        return false
      end
      # TODO: This cannot be validated unless pickup time can be compared to the time the order was placed, not later updates
      # Is pickup time at least min necessary hours from order time? Allow for 30min window to place order.
    end
  end
end
