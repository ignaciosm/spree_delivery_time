require 'spec_helper'

describe "Checkout", type: :feature do

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

    it 'sets the earliest pickup date to the current date' do
      visit spree.checkout_state_path(:delivery)
      # save_and_open_page
      expect(find('#order_pickup_date').value).to eq('2000-03-23')
      expect(page).to have_content('Pickup Date')
    end

    it 'sets the earliest pickup time to soonest time' do
      visit spree.checkout_state_path(:delivery)
      save_and_open_page
      expect(page).to have_content('Pickup Date')
    end


  end

  context 'when next-day delivery is possible' do

  end

  context 'when pickup and delivry time is already set' do

  end
end
