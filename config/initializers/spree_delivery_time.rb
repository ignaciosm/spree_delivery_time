module SpreeDeliveryTime
  class Config
    if Rails.env == 'development' || Rails.env == 'production'
      TIME_ZONE = 'Eastern Time (US & Canada)'
      TIME_OPEN = '09:00:00' # Must be in format 'Hours:Minutes:Seconds'
      TIME_CLOSE = '22:00:00' # Must be in format 'Hours:Minutes:Seconds'
      HOURS_FROM_ORDER_TO_PICKUP = '8' # Minimum number of hours that a pickup can be completed
      HOURS_FROM_PICKUP_TO_DELIVERY = '24' # Minimum number of hours that a dropoff can be completed
      # MAX_DAYS_TO_PICKUP = '60' # Maximum number of days in advance of pickup that an order can be placed
      # MAX_DAYS_TO_DELIVERY = '30' # Maximum number of days from pickup a delivery can be scheduled
    elsif Rails.env == 'test'
      # This is for testing only. Do not modify.
      TIME_ZONE = 'Eastern Time (US & Canada)'
      TIME_OPEN = '08:00:00'
      TIME_CLOSE = '20:00:00'
      HOURS_FROM_ORDER_TO_PICKUP = '8'
      HOURS_FROM_PICKUP_TO_DELIVERY = '9'
      # MAX_DAYS_TO_PICKUP = '60'
      # MAX_DAYS_TO_DELIVERY = '30'
    end
  end
end
