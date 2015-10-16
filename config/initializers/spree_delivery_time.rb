module SpreeDeliveryTime
  class Config
    TIME_ZONE = 'Eastern Time (US & Canada)'
    TIME_OPEN = '09:00:00' # Must be in format 'Hours:Minutes:Seconds'
    TIME_CLOSE = '22:00:00' # Must be in format 'Hours:Minutes:Seconds'
    HOURS_FROM_ORDER_TO_PICKUP = '8' # Minimum number of hours that a pickup can be completed
    HOURS_FROM_PICKUP_TO_DELIVERY = '24' # Minimum number of hours that a dropoff can be completed
    MAX_DAYS_TO_PICKUP = '60' # Maximum number of days in advance of pickup that an order can be placed
    MAX_DAYS_TO_DELIVERY = '30' # Maximum number of days from pickup a delivery can be scheduled
  end
end
