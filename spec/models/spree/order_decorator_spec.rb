require 'spec_helper'

describe Spree::Order do
  before do
    Time.zone = SpreeDeliveryTime::Config::TIME_ZONE
    @order = create(:order)
  end

  describe '#valid_time?' do
    it 'sets the time zone' do
      expect(@order).to receive(:set_time_zone)
      @order.send(:valid_time?)
    end

    context 'when delivery times are not set' do
      it 'returns false and errors when pickup time is nil' do
        @order.update_attributes(pickup: Time.zone.now)
        expect(@order.send(:valid_time?)).to be false
        expect(@order.errors.messages[:delivery_time]).to include('must be specified')
      end

      it 'returns false and errors when dropoff time is nil' do
        @order.update_attributes(dropoff: Time.zone.now)
        expect(@order.send(:valid_time?)).to be false
        expect(@order.errors.messages[:delivery_time]).to include('must be specified')
      end
    end

    context 'when delivery time is invalid' do
      it 'returns false and errors when pickup time is later than dropoff time' do
        @order.update_attributes(pickup: Time.zone.now)
        @order.update_attributes(dropoff: Time.zone.now - 1.hour)
        expect(@order.send(:valid_time?)).to be false
        expect(@order.errors.messages[:pickup_time]).to include('must be earlier than dropoff time')
      end

      it 'returns false and errors when pickup time is not during business hours' do
        @order.update_attributes(pickup: (@order.time_open - 1.hour))
        @order.update_attribute(:dropoff, (@order.time_close))
        expect(@order.send(:valid_time?)).to be false
        expect(@order.errors.messages[:delivery_time]).to include("must be during our business hours: #{@order.time_open.strftime('%T')} - #{@order.time_close.strftime('%T')}")
      end

      it 'returns false and errors when delivery time is not during business hours' do
        @order.update_attributes(pickup: @order.time_open)
        @order.update_attributes(dropoff: (@order.time_close + 1.hour))
        expect(@order.send(:valid_time?)).to be false
        expect(@order.errors.messages[:delivery_time]).to include("must be during our business hours: #{@order.time_open.strftime('%T')} - #{@order.time_close.strftime('%T')}")
      end

      it 'returns false and errors when dropoff time is not at least the minimum configured time to complete a delivery' do
        @order.update_attributes(pickup: @order.time_open + 2.hours)
        @order.update_attributes(dropoff: (@order.pickup + @order.min_hours_from_pickup_to_delivery.hour - 1.hour))
        expect(@order.send(:valid_time?)).to be false
        expect(@order.errors.messages[:dropoff_time]).to include("must be at least #{@order.min_hours_from_pickup_to_delivery} hours from pickup time.")
      end
    end

    context 'when delivery time is valid' do
      it 'returns true when pickup time and dropoff time are valid' do
        @order.update_attributes(pickup: @order.time_open + 2.hours)
        @order.update_attributes(dropoff: (@order.pickup + @order.min_hours_from_pickup_to_delivery.hour))
        expect(@order.send(:valid_time?)).to be true
      end
    end
  end
end