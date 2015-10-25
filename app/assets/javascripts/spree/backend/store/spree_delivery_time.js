(function() {
  Spree.ready(function($) {

    'use strict';

    var togglePickupEdit = function(event) {
      event.preventDefault();

      var link = $(this);
      link.parents('tbody').find('tr.edit-pickup').toggle();
      link.parents('tbody').find('tr.show-pickup').toggle();
    }
    // handle order pickup edit click
    $('a.edit-pickup').click(togglePickupEdit);
    $('a.cancel-pickup').click(togglePickupEdit);

    // handle order pickup save
    $('[data-hook=admin_shipment_form] a.save-pickup').on('click', function (event) {
      event.preventDefault();

      var link = $(this);
      var order_number = link.data('order-number');
      var selected_pickup_date = link.parents('tbody').find('input#order_pickup_date').val();
      var selected_pickup_time = link.parents('tbody').find('select#order_pickup_time').val();
      var url = Spree.url(Spree.routes.orders_api.replace('api/orders', 'admin/orders') + '/' + order_number + '/pickup');

      $.ajax({
        type: 'PUT',
        url: url,
        data: {
          order: {
            pickup_time: selected_pickup_time,
            pickup_date: selected_pickup_date
          },
          token: Spree.api_key
        }
      }).done(function (response) {
        window.location.reload();
      }).error(function (msg) {
        console.log(msg);
      });
    });

    var toggleDropoffEdit = function(event) {
      event.preventDefault();

      var link = $(this);
      link.parents('tbody').find('tr.edit-dropoff').toggle();
      link.parents('tbody').find('tr.show-dropoff').toggle();
    }
    // handle order pickup edit click
    $('a.edit-dropoff').click(toggleDropoffEdit);
    $('a.cancel-dropoff').click(toggleDropoffEdit);

    // handle order pickup save
    $('[data-hook=admin_shipment_form] a.save-dropoff').on('click', function (event) {
      event.preventDefault();

      var link = $(this);
      var order_number = link.data('order-number');
      var selected_dropoff_date = link.parents('tbody').find('input#order_dropoff_date').val();
      var selected_dropoff_time = link.parents('tbody').find('select#order_dropoff_time').val();
      var url = Spree.url(Spree.routes.orders_api.replace('api/orders', 'admin/orders') + '/' + order_number + '/dropoff');

      $.ajax({
        type: 'PUT',
        url: url,
        data: {
          order: {
            dropoff_time: selected_dropoff_time,
            dropoff_date: selected_dropoff_date
          },
          token: Spree.api_key
        }
      }).done(function (response) {
        window.location.reload();
      }).error(function (msg) {
        console.log(msg);
      });
    });
  });
}).call(this);
