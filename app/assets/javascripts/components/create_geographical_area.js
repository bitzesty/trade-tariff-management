$(document).ready(function() {
  var form = document.querySelector(".geographical-area-form");

  if (!form) {
    return;
  }

  var app = new Vue({
    el: form,
    data: function() {
      var data = {
        savedSuccessfully: false,
        errors: {},
        conformanceErrors: {},
        errorsSummary: "",
        parentGroupsList: window.__geographical_area_groups_json
      };

      if (!$.isEmptyObject(window.__geographical_area_json)) {
        data.geographical_area = this.parseGeographicalAreaPayload(window.__geographical_area_json);
      } else {
        data.geographical_area = this.emptyGeographicalArea();
      }

      return data;
    },
    mounted: function() {
      var self = this;

      $(document).ready(function(){
        $(document).on('click', ".js-create-measures-v1-submit-button, .js-workbasket-base-submit-button", function(e) {
          e.preventDefault();
          e.stopPropagation();

          submit_button = $(this);

          self.savedSuccessfully = false;
          WorkbasketBaseSaveActions.toogleSaveSpinner($(this).attr('name'));
          self.errors = [];

          $.ajax({
            url: window.save_url,
            type: "PUT",
            data: {
              step: window.current_step,
              mode: submit_button.attr('name'),
              settings: self.createGeographicalAreaMainStepPayLoad()
            },
            success: function(response) {
              WorkbasketBaseValidationErrorsHandler.hideCustomErrorsBlock();

              if (response.redirect_url !== undefined) {
                setTimeout(function tick() {
                  window.location = resp.redirect_url;
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

              self.errorsSummary = "All bad guys!";
              self.errors = response.responseJSON.errors;
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
      },
      isGroup: function() {
        return this.geographical_area.geographical_code === 'group';
      },
      isRegion: function() {
        return this.geographical_area.geographical_code === 'region';
      },
      isCountry: function() {
        return this.geographical_area.geographical_code === 'country';
      }
    },
    methods: {
      parseGeographicalAreaPayload: function(payload) {
        payload.memberships = objectToArray(payload.memberships);

        return payload;
      },
      emptyGeographicalArea: function() {
        return {
          geographical_code: null,
          geographical_area_id: null,
          parent_geographical_area_group_id: null,
          description: null,
          validity_start_date: null,
          validity_end_date: null,
          operation_date: null,
          memberships: []
        }
      },
      createGeographicalAreaMainStepPayLoad: function() {
        return this.geographical_area;
      },
      triggerAddMemberships: function() {
        if (this.isGroup) {
          this.addingMembers = true;
        } else {
          this.addingToGroups = true;
        }
      },
      closePopups: function() {
        this.addingMembers = false;
        this.addingToGroups = false;
      }
    }
  });
});
