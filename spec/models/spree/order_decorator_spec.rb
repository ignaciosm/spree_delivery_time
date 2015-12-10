require 'spec_helper'

describe Spree::Order do
  before do
    @order = create(:order)
  end

  describe '#delivery_time validator' do
    it 'sets the time zone' do
      expect(@order).to receive(:set_time_zone)
      @order.update_attributes(pickup: time_to_str(Time.zone.parse('09:00')))
    end

    context 'when delivery time is not being updated' do
      it 'does not validate delivery time' do
        expect(@order).to_not receive(:pickup)
        expect(@order).to_not receive(:dropoff)
        expect(@order).to_not receive(:delivery_time_provided?)
        @order.update_attributes(special_instructions: 'hello')
        expect(@order.special_instructions).to eq('hello')
      end
    end

    context 'when delivery times are not set' do
      it 'returns false and errors when dropoff time is nil' do
        @order.update(pickup: Time.zone.parse('09:00:00'))
        expect(@order.errors.messages[:order]).to include("must have pickup and dropoff time in the form of 'YYYY-MM-DD HH:MM:SS'")
      end

      it 'returns false and errors when pickup time is nil' do
        @order.update_attributes(dropoff: Time.zone.parse('09:00:00'))
        expect(@order.errors.messages[:order]).to include("must have pickup and dropoff time in the form of 'YYYY-MM-DD HH:MM:SS'")
      end
    end

    context 'when delivery time is in an invalid range' do
      it 'returns false and errors when pickup time is later than dropoff time' do
        @order.update(pickup: time_to_str(Time.zone.parse('10:00:00')), dropoff: time_to_str(Time.zone.parse('09:00:00')))
        expect(@order.errors.messages[:pickup_time]).to include('must be earlier than dropoff time')
      end

      it 'returns false and errors when pickup time is not during business hours' do
        @order.update_attributes(pickup: (@order.time_open - 1.hour), dropoff: @order.time_close)
        expect(@order.errors.messages[:delivery_time]).to include("must be during our business hours: #{@order.time_open.strftime('%T')} - #{@order.time_close.strftime('%T')}")
      end

      it 'returns false and errors when delivery time is not during business hours' do
        @order.update_attributes(pickup: @order.time_open, dropoff: (@order.time_close + 1.hour))
        expect(@order.errors.messages[:delivery_time]).to include("must be during our business hours: #{@order.time_open.strftime('%T')} - #{@order.time_close.strftime('%T')}")
      end

      it 'returns false and errors when dropoff time is not at least the minimum configured time to complete a delivery' do
        pickup_time = @order.time_open + 2.hours
        dropoff_time = pickup_time + @order.min_hours_from_pickup_to_delivery.hour - 3.hours
        @order.update_attributes(pickup: pickup_time, dropoff: dropoff_time)
        expect(@order.errors.messages[:dropoff_time]).to include("must be at least #{@order.min_hours_from_pickup_to_delivery} hours from pickup time.")
      end

      context 'pickup time relative to current time' do
        before do
          Time.zone = SpreeDeliveryTime::Config::TIME_ZONE
          test_time_now = Time.zone.parse('2000-03-23 09:10:00')
          allow(Time.zone).to receive(:now).and_return(test_time_now)
        end

        it 'returns false and errors when pickup time is not at least the minimum configured time to pickup an order' do
          pickup_time = '2000-03-22 09:00:00'
          dropoff_time = '2000-03-23 09:00:00'
          @order.update_attributes(pickup: pickup_time, dropoff: dropoff_time)
          expect(@order.errors.messages[:pickup_time]).to include("must be at least #{@order.min_hours_from_order_to_pickup} hours from now.")
        end

        it 'allows for a 30 minutes grace period to complete the order before pickup time is checked' do
          pickup_time = '2000-03-23 17:00'
          dropoff_time = '2000-03-24 18:00'
          @order.update_attributes(pickup: pickup_time, dropoff: dropoff_time)
          expect(@order.errors.messages).to be_empty
        end

        context 'when delivery time is in an invalid format' do
          it 'returns false and errors when pickup month is an invalid month' do
            pickup_time = "2015-13-01 09:00:00"
            dropoff_time = "2015-12-01 09:00:00"
            @order.update_attributes(pickup: pickup_time, dropoff: dropoff_time)
            expect(@order.errors.messages[:order]).to include("must have pickup and dropoff time in the form of 'YYYY-MM-DD HH:MM:SS'")
          end

          it 'returns false and errors when pickup time includes a date but no time' do
            pickup_time = "2015-13-01"
            dropoff_time = "2015-12-01 09:00:00"
            @order.update_attributes(pickup: pickup_time, dropoff: dropoff_time)
            expect(@order.errors.messages[:order]).to include("must have pickup and dropoff time in the form of 'YYYY-MM-DD HH:MM:SS'")
          end

          it 'defaults to todays date when pickup time includes a time but no date' do
            pickup_time = "9:00:00"
            dropoff_time = "1999-12-01 09:00:00"
            @order.update_attributes(pickup: pickup_time, dropoff: dropoff_time)
            expect(@order.errors.messages[:pickup_time]).to include("must be earlier than dropoff time")
          end

          it 'returns false and errors when pickup time is an integer' do
            pickup_time = 9
            dropoff_time = "2015-12-01 09:00:00"
            @order.update_attributes(pickup: pickup_time, dropoff: dropoff_time)
            expect(@order.errors.messages[:order]).to include("must have pickup and dropoff time in the form of 'YYYY-MM-DD HH:MM:SS'")
          end

          it 'is valid when pickup time does not include seconds' do
            pickup_time = '2015-12-01 09:00'
            dropoff_time = "2015-12-01 18:00:00"
            @order.update_attributes(pickup: pickup_time, dropoff: dropoff_time)
            expect(@order.errors.messages).to be_empty
          end

          it 'is valid when pickup time includes a negative offset from UTC' do
            pickup_time = '2015-12-01 09:00 -5:00'
            dropoff_time = '2015-12-01 18:00:00 -5:00'
            @order.update_attributes(pickup: pickup_time, dropoff: dropoff_time)
            expect(@order.errors.messages).to be_empty
          end

          it 'is valid when pickup time includes a positive offset from UTC' do
            pickup_time = '2015-12-01 02:00 +12:00'
            dropoff_time = '2015-12-01 11:00:00 +12:00'
            @order.update_attributes(pickup: pickup_time, dropoff: dropoff_time)
            expect(@order.errors.messages).to be_empty
          end
        end
      end
    end
  end
end
