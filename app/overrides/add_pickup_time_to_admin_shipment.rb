Deface::Override.new(:virtual_path => 'spree/admin/orders/_shipment',
  :name => 'add_pickup_time_to_admin_shipment',
  :insert_before => 'tr.show-tracking',
  :text => "<% if order.pickup.present? %>
        <tr class='special_instructions'>
          <td colspan='5'>
            <strong><%= Spree.t(:pickup_time) %>:&nbsp;</strong><%= order.pickup %>
          </td>
        </tr>
      <% end %>
      <% if order.dropoff.present? %>
        <tr class='special_instructions'>
          <td colspan='5'>
            <strong><%= Spree.t(:dropoff_time) %>:&nbsp;</strong><%= order.dropoff %>
          </td>
        </tr>
      <% end %>"
  )