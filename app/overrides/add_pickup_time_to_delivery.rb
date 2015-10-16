Deface::Override.new(:virtual_path => 'spree/checkout/_delivery',
  :name => 'add_pickup_time_to_delivery_options',
  :insert_bottom => 'div.shipment',
  :text => "<p id='minstrs' data-hook>
        <div class='hidden-data' data-utc-offset='<%= (Time.zone.now.utc_offset/3600).to_s %>', data-time-open='<%= @time_open %>', data-time-close='<%= @time_close %>', data-min-hours-pickup='<%= @min_hours_from_order_to_pickup %>' data-min-hours-delivery='<%= @min_hours_from_pickup_to_delivery %>'></div>
        <h4>Pickup Date</h4>
        <input class='form-control' type='date' min='<%= @soonest_pickup_date %>' value='<%= @selected_pickup_date || @soonest_pickup_date %>' data-utc='<%= @selected_pickup_date_utc || @soonest_pickup_date_utc %>' name='order[pickup_date]' id='order_pickup_date'>
        <h4>Pickup Time</h4>
        <select class='form-control' name='order[pickup_time]' id='order_pickup_time'>
          <% @valid_times.each do |valid_time_str| %>
            <% valid_time = Time.zone.parse(valid_time_str) %>
            <% utc_time_str = valid_time.utc.strftime('%H:%M:%S') %>
            <option value='<%= valid_time_str %>' <%= 'selected' if @selected_pickup_time && @selected_pickup_time == valid_time_str %>' data-utc='<%= utc_time_str %>'><%= valid_time.strftime('%l:%M %p') %> - <%= (valid_time + 1.hour).strftime('%l:%M %p') %></option>
          <% end %>
        </select>
        <h4>Dropoff Date</h4>
        <input class='form-control' type='date' min='<%= @soonest_dropoff_date %>' value='<%= @selected_dropoff_date || @soonest_dropoff_date %>' data-utc='<%= @selected_dropoff_date_utc || @soonest_dropoff_date_utc %>' name='order[dropoff_date]' id='order_dropoff_date'>
        <h4>Dropoff Time</h4>
        <select class='form-control' name='order[dropoff_time]' id='order_dropoff_time'>
          <% @valid_times.each do |valid_time_str| %>
            <% valid_time = Time.zone.parse(valid_time_str) %>
            <% utc_time_str = valid_time.utc.strftime('%H:%M:%S') %>
            <option value='<%= valid_time_str %>' <%= 'selected' if @selected_dropoff_time && @selected_dropoff_time == valid_time_str %>' data-utc='<%= utc_time_str %>'><%= valid_time.strftime('%l:%M %p') %> - <%= (valid_time + 1.hour).strftime('%l:%M %p') %></option>
          <% end %>
        </select>
      </p>"
  )
# <input class='form-control' type='time' min = '09:00:00' max='20:00:00' step='01:00:00' value='#{Time.zone.now.hour}:00:00' name='order[dropoff_time]' id='order_dropoff_time'>
