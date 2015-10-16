class AddPickupTimeToSpreeOrder < ActiveRecord::Migration
  def change
    add_column :spree_orders, :pickup, :datetime
    add_column :spree_orders, :dropoff, :datetime
  end
end
