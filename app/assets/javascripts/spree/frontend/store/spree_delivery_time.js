(function() {
  Spree.ready(function($) {
    var validPickupTimes = function() {
      return $('#order_pickup_time').children().filter(function() { return isValidPickupTime($(this).val()) });
    }

    var invalidPickupTimes = function() {
      return $('#order_pickup_time').children().filter(function() { return isInvalidPickupTime($(this).val()) });
    }

    var hideInvalidPickupTimes = function() {
      invalidPickupTimes().filter(function() { $(this).hide() });
      validPickupTimes().filter(function() { $(this).show() });
    }

    var setFirstValidPickupTime = function() {
      var pickupTimeSelectorOption = firstValidPickupTime();
      var pickupTimeStr = $(pickupTimeSelectorOption).val();
      var pickupTimeUtcStr = $(pickupTimeSelectorOption).data('utc');
      setPickupTime(pickupTimeStr, pickupTimeUtcStr);
    }

    var setPickupTime = function(time_str, utc_time_str) {
      $('#order_pickup_time option:selected').prop('selected', false)
      $('#order_pickup_time').val(time_str);
      $('#order_pickup_time').data('utc', utc_time_str);
    }

    var setPickupDate = function(date_str, utc_date_str) {
      $('#order_pickup_date').val(date_str);
      $('#order_pickup_date').data('utc', utc_date_str);
    }

    var setDropoffTime = function(time_str, utc_time_str) {
      $('#order_dropoff_time option:selected').prop('selected', false)
      $('#order_dropoff_time').val(time_str);
      $('#order_dropoff_time').data('utc', utc_time_str);
    }

    var setDropoffDate = function(date_str, utc_date_str) {
      $('#order_dropoff_date').val(date_str);
      $('#order_dropoff_date').data('utc', utc_date_str);
    }

    var setMinDropoffDate = function(date_str) {
      $('#order_dropoff_date').attr('min', date_str);
      if (!Modernizr.inputtypes.date) {
        $( '#order_dropoff_date').datepicker( "option", "minDate", toUtc(new Date($('#order_dropoff_date').attr('min'))) );
      }
    }

    var firstValidPickupTime = function() {
      return validPickupTimes()[0];
    }

    // var getUtcPickupDate = function() {
    //   var parsedDate = parseInt($('#order_pickup_date').data('utc').split('-')[2]);
    //   var date_obj = new Date();
    //   return new Date(date_obj.setDate(parsedDate));
    // }

    var getUtcPickupDate = function() {
      var parsedDate = $('#order_pickup_date').data('utc');
      return toUtc(new Date(parsedDate));
    }

    // var getUtcPickupTime = function() {
    //   var parsedDate = parseInt($('#order_pickup_date').data('utc').split('-')[2]);
    //   var parsedTime = parseInt($('#order_pickup_time option:selected').data('utc'))
    //   var date_obj = zeroMinutesSecondsMilliseconds(new Date());
    //   var pickupDate = new Date(date_obj.setDate(parsedDate));
    //   return new Date(pickupDate.setHours(parsedTime));
    // };

    var getUtcPickupTime = function() {
      var parsedDate = $('#order_pickup_date').data('utc')
      var parsedTime = parseInt($('#order_pickup_time option:selected').data('utc'))
      var date_obj = zeroMinutesSecondsMilliseconds(toUtc(new Date(parsedDate)));
      return new Date(date_obj.setHours(parsedTime));
    };

    // var getPickupTime = function() {
    //   var parsedDate = parseInt($('#order_pickup_date').val().split('-')[2]);
    //   var parsedTime = parseInt($('#order_pickup_time option:selected').val());
    //   var date_obj = zeroMinutesSecondsMilliseconds(new Date());
    //   var pickupDate = new Date(date_obj.setDate(parsedDate));
    //   return new Date(pickupDate.setHours(parsedTime));
    // }

    var getPickupTime = function() {
      var parsedDate = $('#order_pickup_date').val()
      var parsedTime = parseInt($('#order_pickup_time option:selected').val());
      var date_obj = zeroMinutesSecondsMilliseconds(toUtc(new Date(parsedDate)));
      return new Date(date_obj.setHours(parsedTime));
    }

    // var getUtcDropoffTime = function() {
    //   var parsedDate = parseInt($('#order_dropoff_date').data('utc').split('-')[2]);
    //   var parsedTime = parseInt($('#order_dropoff_time option:selected').data('utc'))
    //   var date_obj = zeroMinutesSecondsMilliseconds(new Date());
    //   var dropoffDate = new Date(date_obj.setDate(parsedDate));
    //   return new Date(dropoffDate.setHours(parsedTime));
    // }

    var getUtcDropoffTime = function() {
      var parsedDate = $('#order_dropoff_date').data('utc');
      var parsedTime = parseInt($('#order_dropoff_time option:selected').data('utc'))
      var date_obj = zeroMinutesSecondsMilliseconds(toUtc(new Date(parsedDate)));
      return new Date(date_obj.setHours(parsedTime));
    }

    var zeroMinutesSecondsMilliseconds = function(date_obj) {
      var date_obj = new Date(date_obj.setMinutes(0));
      var date_obj = new Date(date_obj.setSeconds(0));
      return date_obj = new Date(date_obj.setMilliseconds(0));
    }

    // var getPickupDate = function() {
    //   var parsedDate = parseInt($('#order_pickup_date').val().split('-')[2]);
    //   var date_obj = new Date();
    //   return new Date(date_obj.setDate(parsedDate));
    // }

    var getPickupDate = function() {
      var parsedDate = $('#order_pickup_date').val()
      return toUtc(new Date(parsedDate));
    }

    // var getDropoffDate = function() {
    //   var parsedDate = parseInt($('#order_dropoff_date').val().split('-')[2]);
    //   var date_obj = new Date();
    //   return new Date(date_obj.setDate(parsedDate));
    // }

    var getDropoffDate = function() {
      var parsedDate = $('#order_dropoff_date').val()
      return toUtc(new Date(parsedDate));
    }    

    // var getDropoffTime = function() {
    //   var parsedDate = parseInt($('#order_dropoff_date').val().split('-')[2]);
    //   var parsedTime = parseInt($('#order_dropoff_time option:selected').val());
    //   var date_obj = zeroMinutesSecondsMilliseconds(new Date());
    //   var dropoffDate = new Date(date_obj.setDate(parsedDate));
    //   return new Date(dropoffDate.setHours(parsedTime));
    // }

    var getDropoffTime = function() {
      var parsedDate = $('#order_dropoff_date').val()
      var parsedTime = parseInt($('#order_dropoff_time option:selected').val());
      var date_obj = zeroMinutesSecondsMilliseconds(toUtc(new Date(parsedDate)));
      return new Date(date_obj.setHours(parsedTime));
    }

    // var getUtcDropoffDate = function() {
    //   var parsedDate = parseInt($('#order_dropoff_date').data('utc').split('-')[2]);
    //   var date_obj = new Date();
    //   return new Date(date_obj.setDate(parsedDate));
    // }

    var getUtcDropoffDate = function() {
      var parsedDate = $('#order_dropoff_date').data('utc');
      return toUtc(new Date(parsedDate));
    }

    var setTimeStrToUtcDate = function(time_str) {
      var hour = parseInt(time_str.split(':')[0]);
      var date_obj = getPickupDate();
      return set_date = toUtc(new Date(date_obj.setHours(hour)));
    }

    // Returns true or false given a date object
    // Pickup time is valid if it is later than the soonest 
    // pickup time in UTC.
    var isValidPickupTime = function(time_str) {
      return setTimeStrToUtcDate(time_str) >= soonestUtcPickupTime();
    }

    // Returns true or false given a date object
    // Pickup time is invalid if it is earlier than the soonest 
    // pickup time in UTC.
    var isInvalidPickupTime = function(time_str) {
      return setTimeStrToUtcDate(time_str) < soonestUtcPickupTime(); 
    }

    // soonest time in utc the order would be available for pickup
    // current time in utc plus the minimum number of hours for pickup
    var soonestUtcPickupTime = function() {
      var utc_date = toUtc(new Date());
      return new Date(utc_date.setHours(utc_date.getHours() + minHoursFromOrderToPickup()))
    }

    var utcOffset = function() {
      return parseInt($('div.hidden-data').data('utc-offset'));
    }

    var timeOpen = function() {
      return $('div.hidden-data').data('time-open');
    }

    var timeClose = function() {
      return $('div.hidden-data').data('time-close');
    }

    var toUtc = function(date_obj) {
      var utc_date = new Date(date_obj.getUTCFullYear(), date_obj.getUTCMonth(), date_obj.getUTCDate(),  date_obj.getUTCHours(), date_obj.getUTCMinutes(), date_obj.getUTCSeconds());
      return utc_date;
    }

    var minHoursFromOrderToPickup = function() {
      return $('div.hidden-data').data('min-hours-pickup');
    }

    var minHoursFromPickupToDelivery = function() {
      return $('div.hidden-data').data('min-hours-delivery');
    }

    // returns the soonest available delivery date. This is the 
    // first available pickup date plus the minimum number of hours
    // to complete the order and deliver.
    var soonestUtcDropoffTime = function() {
      var utcPickup = getUtcPickupTime();
      return new Date(utcPickup.setHours(utcPickup.getHours() + minHoursFromPickupToDelivery()));
    }

    var hideInvalidDropoffTimes = function() {
      invalidDropoffTimes().filter(function() { $(this).hide() });
      validDropoffTimes().filter(function() { $(this).show() });
    }

    // Resets the val and min val of the dropoff date to the soonest
    // available dropoff date.
    var setFirstValidDropoffTime = function() {
      var dropoffTimeSelectorOption = firstValidDropoffTime();
      var dropoffTimeStr = $(dropoffTimeSelectorOption).val();
      var dropoffTimeUtcStr = $(dropoffTimeSelectorOption).data('utc');
      setDropoffTime(dropoffTimeStr, dropoffTimeUtcStr);
    }

    var setSoonestDropoffDate = function() {
      var soonestUtcDropoff = soonestUtcDropoffTime();
      var soonestDropoff = new Date(soonestUtcDropoff.setHours(soonestUtcDropoff.getHours() + utcOffset()));
      var soonestDropoffDateStr = new Date(soonestDropoff.toDateString()).toISOString().split('T')[0];
      setDropoffDate(soonestDropoffDateStr, soonestDropoffDateStr);
      setMinDropoffDate(soonestDropoffDateStr);
    };

    // Returns array of selector options that meet the criteria of
    // a valid dropoff time.
    var validDropoffTimes = function() {
      return $('#order_dropoff_time').children().filter(function() { return isValidDropoffTime($(this).val()) });
    };

    var firstValidDropoffTime = function() {
      return validDropoffTimes()[0];
    };

    // Returns array of selector options that do not meet the 
    // criteria of a valid dropoff time.
    var invalidDropoffTimes = function() {
      return $('#order_dropoff_time').children().filter(function() { return isInvalidDropoffTime($(this).val()) });
    };

    // Returns true or false given a date object
    // Dropoff time is valid if it is later than the soonest 
    // dropoff time in UTC.
    var isValidDropoffTime = function(time_str) {
      return setTimeStrToUtcDropoffDate(time_str) >= soonestUtcDropoffTime();
    }

    // Returns true or false given a date object
    // Dropoff time is invalid if it is earlier than the soonest 
    // dropoff time in UTC.
    var isInvalidDropoffTime = function(time_str) {
      return setTimeStrToUtcDropoffDate(time_str) < soonestUtcDropoffTime(); 
    };

    var setTimeStrToUtcDropoffDate = function(time_str) {
      var hour = parseInt(time_str.split(':')[0]);
      var date_obj = getDropoffTime();
      return set_date = toUtc(new Date(date_obj.setHours(hour)));
    };

    // Return true or false depending on if currently selected
    // pickup date and time are invalid
    var pickupTimeInvalid = function() {
      var selectedPickupTimeStr = $('#order_pickup_time').val();
      return isInvalidPickupTime(selectedPickupTimeStr);
    };

    var dropoffTimeInvalid = function() {
      var selectedDropoffTimeStr = $('#order_dropoff_time').val();
      return isInvalidDropoffTime(selectedDropoffTimeStr);
    }

    var dropoffDateInvalid = function() {
      return getUtcDropoffTime() < soonestUtcDropoffTime()
    };

    var setPickupTimeIfInvalid = function() {
      if (pickupTimeInvalid()) {
        setFirstValidPickupTime();
      }
    };

    var setDropoffDateifInvalid = function() {
      if (dropoffDateInvalid()) {
        setSoonestDropoffDate();
      } else {
        setDropoffDateMinimum();
      }
    };

    var setDropoffTimeIfInvalid = function() {
      if (dropoffTimeInvalid()) {
        setFirstValidDropoffTime();
      }
    };

    var setDropoffDateMinimum = function() {
      var soonestUtcDropoff = soonestUtcDropoffTime();
      var soonestDropoff = new Date(soonestUtcDropoff.setHours(soonestUtcDropoff.getHours() + utcOffset()));
      var soonestDropoffDateStr = new Date(soonestDropoff.toDateString()).toISOString().split('T')[0];
      // setDropoffDate(soonaestDropoffDateStr, soonestDropoffDateStr);
      setMinDropoffDate(soonestDropoffDateStr);
    }

    if (!Modernizr.inputtypes.date) {
      $('#order_pickup_date').datepicker({dateFormat: 'yy-mm-dd', minDate: toUtc(new Date($('#order_pickup_date').attr('min')))});
      $('#order_dropoff_date').datepicker({dateFormat: 'yy-mm-dd', minDate: toUtc(new Date($('#order_dropoff_date').attr('min')))});
    }


    if ($('#order_pickup_time').length != 0) { 
      setPickupTimeIfInvalid(); // setFirstValidPickupTime();
      hideInvalidPickupTimes();
      setDropoffDateifInvalid(); // setSoonestDropoffDate();
      setDropoffTimeIfInvalid(); // setFirstValidDropoffTime();
      hideInvalidDropoffTimes();
    }

    $('#order_pickup_date').on('change', function(event) {
      var date_str = event.currentTarget.value;
      var utc_date_str = getPickupTime().toISOString().split('T')[0];
      setPickupDate(date_str, utc_date_str);
      setPickupTimeIfInvalid(); // setFirstValidPickupTime();
      hideInvalidPickupTimes();
      setDropoffDateifInvalid(); // setSoonestDropoffDate();
      setDropoffTimeIfInvalid(); // setFirstValidDropoffTime();
      hideInvalidDropoffTimes();
    });

    $('#order_pickup_time').on('change', function(event) {
      var time_str = event.currentTarget.value;
      var utc_time_str = setTimeStrToUtcDate(time_str).getHours() + ':00:00';
      setPickupTime(time_str, utc_time_str);
      var date_str = $('#order_pickup_date').val();
      var utc_date_str = getPickupTime().toISOString().split('T')[0];
      setPickupDate(date_str, utc_date_str);
      setDropoffDateifInvalid(); // setSoonestDropoffDate();
      setDropoffTimeIfInvalid(); // setFirstValidDropoffTime();
      hideInvalidDropoffTimes();
    });

    $('#order_dropoff_date').on('change', function(event) {
      event.preventDefault();
      var date_str = event.currentTarget.value;
      var utc_date_str = getDropoffTime().toISOString().split('T')[0];
      setDropoffDate(date_str, utc_date_str);
      setDropoffTimeIfInvalid(); // setFirstValidDropoffTime();
      hideInvalidDropoffTimes();
    });
  });
}).call(this);