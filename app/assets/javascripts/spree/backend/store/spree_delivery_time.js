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
    debugger;
    var selected_pickup_time = link.parents('tbody').find('input#pickup').val();
    // var unlock = link.parents('tbody').find("input[name='open_adjustment'][data-shipment-number='" + shipment_number + "']:checked").val();
    var url = Spree.url(Spree.routes.orders_api.replace('api/orders', 'orders') + '/' + order_number + '/pickup');
    // debugger

    $.ajax({
      type: 'PUT',
      url: url,
      data: {
        order: {
          pickup: selected_pickup_time
          // unlock: unlock
        },
        token: Spree.api_key
      }
    }).done(function (response) {
      debugger;
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

  // handle tracking edit click
  // $('a.edit-tracking').click(toggleTrackingEdit);
  // $('a.cancel-tracking').click(toggleTrackingEdit);

  // // handle tracking save
  // $('[data-hook=admin_shipment_form] a.save-tracking').on('click', function (event) {
  //   event.preventDefault();

  //   var link = $(this);
  //   var shipment_number = link.data('shipment-number');
  //   var tracking = link.parents('tbody').find('input#tracking').val();
  //   var url = Spree.url(Spree.routes.shipments_api + '/' + shipment_number + '.json');

  //   $.ajax({
  //     type: 'PUT',
  //     url: url,
  //     data: {
  //       shipment: {
  //         tracking: tracking
  //       },
  //       token: Spree.api_key
  //     }
  //   }).done(function (data) {
  //     link.parents('tbody').find('tr.edit-tracking').toggle();

  //     var show = link.parents('tbody').find('tr.show-tracking');
  //     show.toggle();
  //     show.find('.tracking-value').html($("<strong>").html("Tracking: ")).append(data.tracking);
  //   });
  // });
  });
}).call(this);
