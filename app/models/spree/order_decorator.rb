Spree::Order.state_machine.before_transition :to => :payment, :do => :valid_time?

def valid_time?
  Time.zone = SpreeDeliveryTime::Config::TIME_ZONE || "UTC"
  open_time = Time.zone.parse(SpreeDeliveryTime::Config::TIME_OPEN) || "00:00:00"
  close_time = Time.zone.parse(SpreeDeliveryTime::Config::TIME_CLOSE) || "23:59:59"
  # Is both pickup and dropoff time present?
  if (dropoff.nil? || pickup.nil?)
    errors.add(:delivery_time, 'must be specified')
    return false
  # Is pickup time later than dropoff time?
  elsif pickup > dropoff
    errors.add(:pickup, 'must be earlier than dropoff time')
    return false
  # Is pickup and dropoff time during operating hours?
  elsif (pickup.hour < open_time.hour || pickup.hour > close_time.hour || dropoff.hour < open_time.hour || dropoff.hour > close_time.hour)
    errors.add(:delivery_time, "must be during our business hours: #{opent_time.strftime('%T')} - #{close_time.strftime('%T')}")
    return false
  end
end