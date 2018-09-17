window.Parsley.addValidator('minDateTo', {
  requirementType: 'string',
  validateString: function(value, requirement) {
    if (!value || !requirement) {
      return true;
    }

    var date = moment(value, "DD/MM/YYYY, h:mm A", false);
    var val = moment($(requirement).val(), "DD/MM/YYYY, h:mm A", false);

    if (!val.isValid() || !date.isValid()) {
      return true;
    }

    return date.diff(val, "days") >= 0;
  },
  messages: {
    en: 'Date should be greater than Start date'
  }
});

window.Parsley.addValidator('maxDateTo', {
  requirementType: 'string',
  validateString: function(value, requirement) {
    if (!value || !requirement) {
      return true;
    }

    var date = moment(value, "DD/MM/YYYY, h:mm A", false);
    var val = moment($(requirement).val(), "DD/MM/YYYY, h:mm A", false);

    if (!val.isValid() || !date.isValid()) {
      return true;
    }

    return val.diff(date, "days") >= 0;
  },
  messages: {
    en: 'Date should be smaller than End date'
  }
});

window.Parsley.addValidator('moment', {
  requirementType: 'string',
  validateString: function(value, requirement) {
    if (!value) {
      return true;
    }

    var date = moment(value, "DD/MM/YYYY, h:mm A", false);

    return date.isValid();
  },
  messages: {
    en: 'Date is not valid'
  }
});
