Deface::Override.new(:virtual_path => 'spree/admin/orders/_shipment',
  :name => 'add_pickup_time_to_admin_shipment',
  :insert_before => 'tr.edit-tracking',
  :text => "
        <tr class='edit-pickup is-hidden total'>
          <td colspan='5'>
            <label><%= Spree.t(:pickup_date) %>:</label>
            <input id='order_pickup_date' class='form-control' type='date' value='<%= order.date(:pickup) if order.pickup %>' name='order[pickup_date]'>
            <label><%= Spree.t(:pickup_time) %>:</label>
            <select id='order_pickup_time' class='select2 select_item_total' name='order[pickup_time]'>
              <% @valid_times.each do |valid_time_str| %>
                <% valid_time = Time.zone.parse(valid_time_str) %>
                <% utc_time_str = valid_time.utc.strftime('%H:%M:%S') %>
                <option value='<%= valid_time_str %>' <%= 'selected' if order.pickup && @order.time(:pickup) == valid_time_str %>' data-utc='<%= utc_time_str %>'><%= valid_time.strftime('%l:%M %p') %> - <%= (valid_time + 1.hour).strftime('%l:%M %p') %></option>
              <% end %>
            </select>
          </td>
          <td class='actions'>
            <% if can? :update, order %>
              <%= link_to_with_icon 'cancel', Spree.t('actions.cancel'), '#', :class => 'cancel-pickup btn btn-primary btn-sm', :data => {:action => 'cancel'}, :title => Spree.t('actions.cancel'), :no_text => true %>
              <%= link_to_with_icon 'save', Spree.t('actions.save'), '#', :class => 'save-pickup btn btn-success btn-sm', :data => {'order-number' => order.number, :action => 'save'}, :title => Spree.t('actions.save'), :no_text => true %>
            <% end %>
          </td>
        </tr>

        <tr class='show-pickup total'>
          <td colspan='5'>
            <strong><%= Spree.t(:pickup_time) %>:&nbsp;</strong><%= order.delivery_time_str(:pickup) if order.pickup %>
          </td>
          <td class='actions text-center'>
            <% if can? :update, shipment %>
              <%= link_to_with_icon 'edit', Spree.t('edit'), '#', class: 'edit-pickup btn btn-primary btn-sm', data: {action: 'edit'}, title: Spree.t('edit'), no_text: true %>
            <% end %>
          </td>
        </tr>

        <tr class='edit-dropoff is-hidden total'>
          <td colspan='5'>
            <label><%= Spree.t(:dropoff_date) %>:</label>
            <input id='order_dropoff_date' class='form-control' type='date' value='<%= order.date(:dropoff) if order.dropoff %>' name='order[dropoff_date]'>
            <label><%= Spree.t(:dropoff_time) %>:</label>
            <select id='order_dropoff_time' class='select2 select_item_total' name='order[dropoff_time]'>
              <% @valid_times.each do |valid_time_str| %>
                <% valid_time = Time.zone.parse(valid_time_str) %>
                <% utc_time_str = valid_time.utc.strftime('%H:%M:%S') %>
                <option value='<%= valid_time_str %>' <%= 'selected' if @order.dropoff && @order.time(:dropoff) == valid_time_str %>' data-utc='<%= utc_time_str %>'><%= valid_time.strftime('%l:%M %p') %> - <%= (valid_time + 1.hour).strftime('%l:%M %p') %></option>
              <% end %>
            </select>
          </td>
          <td class='actions'>
            <% if can? :update, order %>
              <%= link_to_with_icon 'cancel', Spree.t('actions.cancel'), '#', :class => 'cancel-dropoff btn btn-primary btn-sm', :data => {:action => 'cancel'}, :title => Spree.t('actions.cancel'), :no_text => true %>
              <%= link_to_with_icon 'save', Spree.t('actions.save'), '#', :class => 'save-dropoff btn btn-success btn-sm', :data => {'order-number' => order.number, :action => 'save'}, :title => Spree.t('actions.save'), :no_text => true %>
            <% end %>
          </td>
        </tr>

        <tr class='show-dropoff total'>
          <td colspan='5'>
            <strong><%= Spree.t(:dropoff_time) %>:&nbsp;</strong><%= order.delivery_time_str(:dropoff) if order.dropoff %>
          </td>
          <td class='actions text-center'>
            <% if can? :update, order %>
              <%= link_to_with_icon 'edit', Spree.t('edit'), '#', class: 'edit-dropoff btn btn-primary btn-sm', data: {action: 'edit'}, title: Spree.t('edit'), no_text: true %>
            <% end %>
          </td>
        </tr>
     "
  )