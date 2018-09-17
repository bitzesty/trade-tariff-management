$(document).ready(function(){
  $('[data-behaviour~=datepicker]').each(function() {
    var picker = new Pikaday({
      showTime: false,
      field: $(this)[0],
      format: "DD/MM/YYYY",
      blurFieldOnSelect: true
    });

    if (input.value === "") {
      // we set current date only if we don't have
      // already a value
      picker.setDefaultDate(new Date());
    }
  });

  $('.datepicker').each(function() {
    var field = $(this);

    new Pikaday({
      showTime: false,
      field: $(this)[0],
      format: "DD/MM/YYYY",
      blurFieldOnSelect: true,
      onSelect: function() {
        $(this).trigger("change");
      }
    });
  });

  var start_date = $(".start-date");
  var end_date = $(".end-date");

  var time_picker = start_date.hasClass('time-picker');
  if (start_date.length > 0 && end_date.length > 0) {
    var start = new Pikaday({
      field: start_date[0],
      blurFieldOnSelect: true,
      format: "DD/MM/YYYY" + (time_picker ? ", h:mm A" : ""),
      showTime: time_picker,
      showMinutes: time_picker,
      showSeconds: false,
      use24hour: false,
      incrementHourBy: 1,
      incrementMinuteBy: 1,
      incrementSecondBy: 1,
      autoClose: true,
      timeLabel: null,
      onSelect: function(value) {
        start_date.trigger("change");

        end.setMinDate(this.getMoment().toDate());
        start.setStartRange(this.getMoment().toDate());
        end.setStartRange(this.getMoment().toDate());
      }
    });

    time_picker = end_date.hasClass('time-picker');
    var end = new Pikaday({
      field: end_date[0],
      blurFieldOnSelect: true,
      format: "DD/MM/YYYY" + (time_picker ? ", h:mm A" : ""),
      showTime: time_picker,
      showMinutes: time_picker,
      showSeconds: false,
      use24hour: false,
      incrementHourBy: 1,
      incrementMinuteBy: 1,
      incrementSecondBy: 1,
      autoClose: true,
      timeLabel: null,
      onSelect: function(value) {
        end_date.trigger("change");

        start.setMaxDate(this.getMoment().toDate());
        start.setEndRange(this.getMoment().toDate());
        end.setEndRange(this.getMoment().toDate());

      }
    });

    start_date.on("change", function() {
      if (!$(this).val()) {
        end.setStartRange(null);
        start.setStartRange(null);
        start.setMinDate(moment().subtract(100, "years").toDate());
      }
    });

    end_date.on("change", function() {
      if (!$(this).val()) {
        end.setEndRange(null);
        start.setEndRange(null);
        start.setMaxDate(moment().add(300, "years").toDate());
      }
    });
  }
});
