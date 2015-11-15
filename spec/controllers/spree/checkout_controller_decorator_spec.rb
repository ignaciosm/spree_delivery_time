require 'spec_helper'

module Spree
  describe CheckoutController, type: :controller do
    let(:token) { 'some_token' }
    let(:user) { create(:user) }
    let(:order) { create(:order) }

    let(:address_params) do
      address = FactoryGirl.build(:address)
      address.attributes.except('created_at', 'updated_at')
    end

    let(:order_params) do
      {'utf8'=>'✓', '_method'=>'patch', 'authenticity_token'=>'EsSQ+DlPGXckhmkGxSHdnwVYbDTvx5VtuUc1KGFZZFuiWn5KNIKqRtBiFlGdDAoQOq1gL+Kl1qXom6hlCm29PQ==', 'order'=>{'shipments_attributes'=>{'0'=>{'selected_shipping_rate_id'=>'8', 'id'=>'4'}}, 'special_instructions'=>'', 'pickup'=>'2015-11-20 14:00:00 -0500', 'dropoff'=>'2015-11-21 14:00:00 -0500'}, 'commit'=>'Save and Continue', 'controller'=>'spree/checkout', 'action'=>'update', 'state'=>'delivery'}
    end

    before do
      allow(controller).to receive_messages try_spree_current_user: user
      allow(controller).to receive_messages spree_current_user: user
      allow(controller).to receive_messages current_order: order
      allow(controller).to receive_messages check_authorization: true
      # allow(controller).to receive_messages ensure_checkout_allowed: true
      # allow(controller).to receive_messages ensure_valid_state: true

      # Must have *a* shipping method and a payment method so updating from address works
      allow(order).to receive(:available_shipping_methods).and_return [create(:shipping_method)]
      allow(order).to receive(:ensure_available_shipping_rates).and_return true
      allow(order).to receive(:payment_required?).and_return true
      order.line_items << FactoryGirl.create(:line_item)
    end

    context 'when valid parameters are provided' do
      it 'does something' do
        spree_post :update, state: 'delivery', order: {'special_instructions'=>'', 'pickup'=>'2015-11-20 14:00:00 -0500', 'dropoff'=>'2015-11-21 14:00:00 -0500'}
        expect(order.pickup).to eq('2015-11-20 14:00:00 -0500')
      end
    end

    context 'when invalid parameters are provided' do
      it 'raises an error when delivery time is not provided' do
        order_params = {'pickup'=>'2015-11-20 14:00:00 -0500', 'dropoff'=>''}
        spree_post :update, state: 'delivery', order: order_params
        byebug
        expect(order.pickup).to eq('2015-11-20 14:00:00 -0500')
      end

      it 'raises an error when delivery time is not in the right format' do
        order_params = {'pickup'=>'2015-11-20 14:00:00 -0500', 'dropoff'=>''}
        spree_post :update, state: 'delivery', order: order_params
        expect(order.pickup).to eq('2015-11-20 14:00:00 -0500')
      end
    end
  end
end

# describe Spree::ProductsController do
#   it "can see all the products" do
#     spree_get :index
#   end
# end