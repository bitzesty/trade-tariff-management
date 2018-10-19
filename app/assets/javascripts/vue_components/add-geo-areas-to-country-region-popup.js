Vue.component("add-geo-areas-to-country-region-popup", {
  template: "#add-geo-areas-to-country-region-popup-template",
  props: ["geographicalArea", "validityStartDate", "onClose", "open"],
  data: function() {
    return {
      memberships: [],
      valid: true,
      errors: [],
      processing: false
    };
  },
  mounted: function() {
    if (this.geographicalArea.geographical_area_memberships.length > 0) {
      this.memberships = this.geographicalArea.geographical_area_memberships.map(function(m) {
        return clone(m);
      });
    } else {
      this.addMembership();
    }
  },
  methods: {
    addMembership: function() {
      var start_date = moment(this.geographicalArea.validity_start_date, "DD/MM/YYYY", true);

      this.memberships.push({
        geographical_area: this.geographicalArea,
        geographical_area_id: this.geographicalArea.geographical_area_id,
        validity_start_date: start_date.isValid() ? this.geographicalArea.validity_start_date : null,
        validity_end_date: null,
        geographical_area_group_sid: null
      });
    },
    validate: function(resolve, reject) {
      var self = this;

      this.errors = {};
      this.errorSummary = "";
      this.valid = true;

      var codesArray = this.codesArray;

      if (this.codes.trim().length === 0) {
        this.errors.codes = "One or more codes must be entered."
        this.valid = false;
        this.errorSummary = "Memberships could not be added because one or more required fields are missing.";
      }

      if (!this.join_date) {
        this.errors.join_date = "A date must be entered here";
        this.valid = false;
        this.errorSummary = "Memberships could not be added because one or more required fields are missing.";
      }

      if (!this.valid) {
        return reject();
      }

      if (moment(this.join_date, "DD/MM/YYYY", true).isValid() === false) {
        this.errors.join_date = "The join date must be valid";
        this.valid = false;
        this.errorSummary = "Memberships could not be added because invalid data has been entered for one or more fields.";
      }

      if (this.leave_date && moment(this.leave_date, "DD/MM/YYYY", true).isValid() === false) {
        this.errors.leave_date = "The leave date, if entered, must be valid";
        this.valid = false;
        this.errorSummary = "Memberships could not be added because invalid data has been entered for one or more fields.";
      }

      if (!this.valid) {
        return reject();
      }

      $.ajax({
        type: "GET",
        url: "/geographical_areas/check_multiple",
        data: {
          codes: codesArray
        },
        success: function(codes) {
          codesArray.forEach(function(c) {
            if (codes[c] == "null" && !self.errors.codes) {
              self.valid = false;

              self.errors = {
                codes: "One or more of the codes entered are not recognised – either they are not valid ISO codes or they do not exist in the TAP database (you may need to add a new country or region)."
              };

              self.errorSummary = "Memberships could not be added because invalid data has been entered for one or more fields.";
            }
          });

          if (self.valid) {
            resolve(codes);
          } else {
            reject();
          }
        },
        error: reject
      });
    },
    addMemberships: function() {
      var self = this;
      var components = this.measureComponents;

      this.processing = true;

      this.validate(function(areas) {
        for (var k in areas) {
          if (!areas.hasOwnProperty(k)) {
            continue;
          }

          var area = areas[k];

          self.geographicalArea.memberships.push({
            geographical_area: area,
            geographical_area_id: area.geographical_area_id,
            geographical_area_group_sid: self.geographicalArea.geographical_area_id,
            validity_start_date: self.join_date,
            validity_end_date: self.leave_date
          });
        }

        self.onClose();
      }, function() {
        self.processing = false;
      });
    },
    triggerClose: function() {
      this.onClose();
    }
  }
});
