function AdditionalCodesValidator(data) {
  this.data = data;
  this.errors = {};
  this.valid = true;
  this.level = "one";
  this.summary = "";
}

AdditionalCodesValidator.prototype.validate = function(action) {
  this.action = action;

  if (!this.validateLevelOne()) {
    this.valid = false;
    return this.gatherResults();
  }

  if (action === "submit_for_cross_check") {
    if (!this.validateLevelTwo()) {
      this.valid = false;
      return this.gatherResults();
    }

    if (!this.validateLevelThree()) {
      this.valid = false;
      return this.gatherResults();
    }
  }

  return this.gatherResults();
};

AdditionalCodesValidator.prototype.validateLevelOne = function() {
  var valid = true;
  var self = this;
  this.level = "one";

  if (this.data.workbasket_name.trim().length === 0) {
    this.errors.workbasket_name = "You must specify a workbasket name. The name must contain at least one word.";
    valid = false;
  }

  if (this.data.validity_start_date && moment(this.data.validity_start_date, "DD/MM/YYYY", true).isValid() == false) {
    this.errors.validity_start_date = "You must specify valid a date here.";
    valid = false;
  }

  var invalidCodes = any(this.data.additional_codes, function(code, index) {
    var hasError = code.additional_code.trim().length > 0 && !code.additional_code.match("^[0-9a-zA-Z]{3}$");

    if (hasError) {
      self.errors["additional_code_" + index] = "invalid";
    }

    return hasError;
  });

  if (invalidCodes) {
    this.errors.additional_codes = "One or more of the codes you have entered is invalid. Each code must be three characters long.";
    valid = false;
  }

  return valid;
};

AdditionalCodesValidator.prototype.validateLevelTwo = function() {
  this.level = "two";
  var valid = true;
  var self = this;

  var start_date = moment(this.data.validity_start_date, "DD/MM/YYYY", true);
  var end_date = moment(this.data.validity_end_date, "DD/MM/YYYY", true);

  if (!this.data.validity_start_date) {
    this.errors.validity_start_date = "You must specify a date here.";
    valid = false;
  } else if (!start_date.isValid()) {
    this.errors.validity_start_date = "You must specify valid a date here.";
    valid = false;
  }

  if (this.data.validity_end_date) {
    if (!end_date.isValid()) {
      this.errors.validity_end_date = "The end date, if specified, must be a valid date.";
      valid = false;
    } else if (end_date.diff(start_date, "days") <= 0) {
      this.errors.validity_end_date = "The end date, if specified, must be after the start date specified above.";
      valid = false;
    }
  }

  var invalidCodes = any(this.data.additional_codes, function(code, index) {
    var incompleteCode = code.additional_code.trim().length == 0;
    var incompleteDescription = code.description.trim().length == 0;
    var incompleteType = !code.additional_code_type_id;

    // if all blank, ignore
    if (incompleteCode && incompleteDescription && incompleteType) {
      return false;
    }

    if (incompleteCode) {
      self.errors["additional_code_" + index] = "invalid";
    }

    if (incompleteDescription) {
      self.errors["description_" + index] = "invalid";
    }

    if (incompleteType) {
      self.errors["additional_code_type_id_" + index] = "invalid";
    }

    return incompleteCode || incompleteDescription || incompleteType;
  });

  if (invalidCodes) {
    this.errors.additional_codes = "One or more of the specified codes is incomplete.";
    valid = false;
  }

  return valid;
};

AdditionalCodesValidator.prototype.validateLevelThree = function() {
  this.level = "three";
  var valid = true;

  return valid;
};

AdditionalCodesValidator.prototype.gatherResults = function() {
  this.setSummary();

  return {
    valid: this.valid,
    level: this.level,
    summary: this.summary,
    errors: this.errors
  };
};

AdditionalCodesValidator.prototype.setSummary = function() {
  if (this.level == "one" && this.action == "save_progress") {
    this.summary = "You cannot save progress yet because you have not entered the minimum required data.";
  } else if (this.level == "one") {
    this.summary = "You cannot submit for cross-check yet because you have not entered the minimum required data.";
  } else if (this.level == "two" && this.action == "save_progress") {
    this.summary = "You cannot save progress yet because there is invalid data that cannot be saved.";
  }  else if (this.level == "two") {
    this.summary = "You cannot submit for cross-check yet because there is invalid data that cannot be saved..";
  } else if (this.level == "three") {
    this.summary = "There is missing and/or invalid data on this page.";
  } else if (this.level == "four") {
    this.summary = "There are conformance errors that mean the additional codes are not ready to be submitted yet.";
  }
};