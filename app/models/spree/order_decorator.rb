Spree::Order.state_machine.before_transition :to => :payment, :do => :valid_time?

module Spree
  Order.class_eval do
    include DeliveryTimeControllerHelper

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

    def delivery_time_str(time_sym)
      return unless [:pickup, :dropoff].include?(time_sym)
      return "#{date_str(time_sym)} #{time_low(time_sym)}"
    end

    private

    def valid_time?
      set_time_zone
      # Is both pickup and dropoff time present?
      if (dropoff.nil? || pickup.nil?)
        errors.add(:delivery_time, 'must be specified')
        return false
      # Is pickup time later than dropoff time?
      elsif (pickup > dropoff)
        errors.add(:pickup_time, 'must be earlier than dropoff time')
        return false
      # Is pickup and dropoff time during operating hours?
      elsif (pickup.hour < time_open.hour || pickup.hour > time_close.hour || dropoff.hour < time_open.hour || dropoff.hour > time_close.hour)
        errors.add(:delivery_time, "must be during our business hours: #{time_open.strftime('%T')} - #{time_close.strftime('%T')}")
        return false
      # TODO: This cannot be validated unless pickup time can be compared to the time the order was placed, not later updates
      # Is pickup time at least min necessary hours from order time? Allow for 30min window to place order.
      # Is dropoff time at least min necessary hours from pickup time?
      elsif (dropoff < (pickup + min_hours_from_pickup_to_delivery.hours))
        errors.add(:dropoff_time, "must be at least #{min_hours_from_pickup_to_delivery} hours from pickup time.")
        return false
      end
      true
    end
  end
end
