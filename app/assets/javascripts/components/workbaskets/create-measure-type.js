$(document).ready(function(){
  var form = document.querySelector(".js-create-measure-type-form");

  if (!form) {
    return;
  }

  var app = new Vue({
    el: form,
    data: function(){
      var data = {
        savedSuccessfully: false,
        errors: {},
        conformanceErrors: {},
        errorsSummary: ""
      };

      if (!$.isEmptyObject(window.__measure_type_json)) {
        data.measure_type = this.parseMeasureTypePayload(window.__measure_type_json);
      } else {
        data.measure_type = this.emptyMeasureType();
      }

      data.measure_type_series_list = window.__measure_type_series_list_json;
      return data;
    },
    mounted: function() {
      var self = this;
      $(document).ready(function(){
        $(document).on("click", ".js-create-measures-v1-submit-button, .js-workbasket-base-submit-button", function(e){
          e.preventDefault();
          e.stopPropagation();

          submit_button = $(this);

          self.savedSuccessfully = false;
          WorkbasketBaseSaveActions.toogleSaveSpinner($(this).attr('name'));

          self.errors = {};
          self.conformanceErrors = {};
          $.ajax({
            url: window.save_url,
            type: "PUT",
            data: {
              step: window.current_step,
              mode: submit_button.attr('name'),
              settings: self.createMeasureTypeMainStepPayLoad()
            },
            success: function(response) {
              WorkbasketBaseValidationErrorsHandler.hideCustomErrorsBlock();

              if (response.redirect_url !== undefined) {
                setTimeout(function tick() {
                  window.location = response.redirect_url;
                }, 1000);

              } else {
                WorkbasketBaseSaveActions.unlockButtonsAndHideSpinner();
                self.savedSuccessfully = true;
              }
            },
            error: function(response) {
              WorkbasketBaseValidationErrorsHandler.hideCustomErrorsBlock();
              WorkbasketBaseSaveActions.unlockButtonsAndHideSpinner();

              if (response.status == 500) {
                alert("There was a server error which prevented the additional codes to be saved. Please try again in a few moments.");
                return;
              }

              json_resp = response.responseJSON;

              self.errorsSummary = json_resp.errors_summary;
              self.errors = json_resp.errors;
              self.conformanceErrors = json_resp.conformance_errors;
            }
          });
        });
      });
    },
    computed: {
      hasErrors: function() {
        return Object.keys(this.errors).length > 0;
      },
      hasConformanceErrors: function() {
        return Object.keys(this.conformanceErrors).length > 0;
      }
    },
    methods: {
      parseMeasureTypePayload: function(payload) {
        return {
          measure_type_series_id: payload.measure_type_series_id,
          measure_type_id: payload.measure_type_id,
          description: payload.description,
          validity_start_date: payload.validity_start_date,
          validity_end_date: payload.validity_end_date,
          operation_date: payload.operation_date
        };
      },
      emptyMeasureType: function() {
        return {
          measure_type_series_id: null,
          measure_type_id: null,
          description: null,
          validity_start_date: null,
          validity_end_date: null,
          operation_date: null
        };
      },
      createMeasureTypeMainStepPayLoad: function() {
        return {
          measure_type_series_id: this.measure_type.measure_type_series_id,
          measure_type_id: this.measure_type.measure_type_id,
          description: this.measure_type.description,
          validity_start_date: this.measure_type.validity_start_date,
          validity_end_date: this.measure_type.validity_end_date,
          operation_date: this.measure_type.operation_date
        };
      }
    }
  });
});
