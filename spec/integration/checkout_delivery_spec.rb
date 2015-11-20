require 'spec_helper'

feature "Checkout", js: true do

  let(:token) { 'some_token' }
  let(:user) { create(:user) }
  let(:order) { create(:order) }

  before(:each) do
    order = OrderWalkthrough.up_to(:delivery)
    allow(order).to receive_messages confirmation_required?: true
    allow(order).to receive_messages(:available_payment_methods => [ create(:credit_card_payment_method) ])

    user = create(:user)
    order.user = user
    order.update!

    allow_any_instance_of(Spree::CheckoutController).to receive_messages(current_order: order)
    allow_any_instance_of(Spree::CheckoutController).to receive_messages(try_spree_current_user: user)
  end

  context 'when soonest pickup is the same day' do
    before do
      Time.zone = SpreeDeliveryTime::Config::TIME_ZONE
      test_time_now = Time.zone.parse('2000-03-23 09:10:00')
      allow(Time.zone).to receive(:now).and_return(test_time_now)
    end

    context 'when delivery time has not yet been set' do
      it 'sets the earliest pickup date to the current date' do
        visit spree.checkout_state_path(:delivery)
        expect(find('#order_pickup_date').value).to eq('2000-03-23')
      end

      xit 'sets the pickup time to soonest possible pickup time', js: true do
        visit spree.checkout_state_path(:delivery)
        # save_and_open_page
        # byebug
        expect(find('#order_pickup_time').value).to eq('17:00:00')
      end

      it 'sets the dropoff date to the soonest possible dropoff date' do

      end

      it 'sets the dropoff time to the soonest possible dropoff time' do

      end
    end

    context 'when delivery time has already been set' do

    end

  end

  context 'when next-day delivery is possible' do

  end

  context 'when pickup and delivry time is already set' do

  end
end
