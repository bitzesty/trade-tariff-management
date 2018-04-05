//= require vue
//= require vue-resource

function debounce(func, wait, immediate) {
  var timeout;
  return function() {
    var context = this, args = arguments;
    var later = function() {
      timeout = null;
      if (!immediate) func.apply(context, args);
    };
    var callNow = immediate && !timeout;
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
    if (callNow) func.apply(context, args);
  };
};

function Origin(el) {
  this.choice = el;
  this.select = el.find("select");
  this.radio = el.find("input[type='radio']");
  this.target = el.next();

  this.onSelect = undefined;
  this.onExclusionsUpdate = undefined;

  this.deselect = this.deselect.bind(this);

  this.geographical_area_id = null;
  this.selected = [];

  this.init();
  this.bindEvents();
}

Origin.prototype.init = function () {
  this.select.select2({
    placeholder: "― start typing ―",
    theme: "bootstrap",
    allowClear: true,
    templateSelection: function(state) {
      if (!state.id) {
        return state.text;
      }

      return $("<div class='item'>" + state.id + " - " + state.text + "(" + state.id + ")</div>");
    },
    templateResult: function(state) {
      if (!state.id) {
        return state.text;
      }

      return $("<span class='selection" + (state.disabled ? ' selection--strikethrough' : '') + "'><span class='option-prefix option-prefix--series'>" + state.id + "</span> " + state.text + "(" + state.id + ")</span>");
    }
  });
};

Origin.prototype.bindEvents = function () {
  var self = this;

  this.select.on("change", function() {
    var val = self.select.val();

    if (val)  {
      self.radio.prop("checked", true).trigger("change");
      self.geographical_area_id = val;

      if (window.geographical_areas_json[self.geographical_area_id].length > 0) {
        self.target.find(".exclusions-target").empty();
        self.addExclusion();
        self.openExclusions();
      }

      if (self.onSelect !== undefined) {
        self.onSelect(self);
      }
    }
  });

  this.radio.on("change", function() {
    var checked = self.radio[0].checked;

    if (checked) {
      if (self.select.length <= 0) {
        self.geographical_area_id = '1011';

        if (window.geographical_areas_json[self.geographical_area_id].length > 0) {
          self.target.find(".exclusions-target").empty();
          self.addExclusion();
          self.openExclusions();
        }
      }

      if (self.onSelect !== undefined) {
        self.onSelect(self);
      }
    }
  });

  this.target.on("click", ".js-add-country-exclusion", function(e) {
    e.preventDefault();
    e.stopPropagation();

    self.addExclusion();
  });

  this.target.on("change", "select", function() {
    self.updateSelectedValues();
  })
};

Origin.prototype.openExclusions = function () {
  this.target.removeClass("js-hidden");
};

Origin.prototype.closeExclusions = function () {
  this.target.addClass("js-hidden");
  this.target.find(".exclusions-target").empty();
};

Origin.prototype.deselect = function () {
  this.closeExclusions();

  if (this.select.length > 0) {
    this.select.val(null).trigger("change");
  }

  this.geographical_area_id = null;
  this.selected = [];
};

Origin.prototype.addExclusion = function () {
  var self = this;
  var first = this.target.find(".exclusions-target .row").length === 0;

  var html = $("<div class='row exclusion'><div class='col-md-4'><select class='exclusion-select'><option value></option></select></div>" + (first ? "" : "<div class='col-md-2'><a href='#' class='text-danger'>Remove</a></div>") + "</div>");

  var options = window.geographical_areas_json[this.geographical_area_id].map(function(option) {
    option.id = option.geographical_area_id;
    option.text = option.description;

    return option;
  });

  this.target.find(".exclusions-target").append(html);

  html.find("select").select2({
    data: options,
    theme: "bootstrap",
    placeholder: "― start typing ―",
    allowClear: true,
    templateSelection: function(state) {
      if (!state.id) {
        return state.text;
      }

      return $("<div class='item'>" + state.geographical_area_id + " - " + state.description + "(" + state.geographical_area_id + ")</div>");
    },
    templateResult: function(state) {
      if (!state.id) {
        return state.text;
      }

      return $("<span class='selection" + (state.disabled ? ' selection--strikethrough' : '') + "'><span class='option-prefix option-prefix--series'>" + state.geographical_area_id + "</span> " + state.description + "(" + state.geographical_area_id + ")</span>");
    }
  });

  html.find("a.text-danger").one("click", function(e) {
    e.preventDefault();
    e.stopPropagation();

    html.remove();

    self.updateSelectedValues();
  });
};

Origin.prototype.updateSelectedValues = function () {
  var values = [];

  this.target.find("select").each(function() {
    var val = $(this).val();

    if (val) {
      values.push(val);
    }
  });

  this.selected = values;

  if (this.onExclusionsUpdate !== undefined) {
    this.onExclusionsUpdate(values);
  }
}

$(document).ready(function() {

  var form = document.querySelector(".measure-form");

  if (!form) {
    return;
  }

  Vue.component('custom-select', {
    props: [
      "url",
      "value",
      "options",
      "placeholder",
      "labelField",
      "valueField",
      "searchField",
      "codeField",
      "minLength",
      "dateSensitive",
      "drilldownName",
      "drilldownValue",
      "drilldownRequired"
    ],
    data: function() {
      return {
        condition: {},
        start_date: window.measure_start_date,
        end_date: window.measure_end_date,
      }
    },
    template: "#selectize-template",
    mounted: function () {
      var vm = this;

      var options = {
        allowClear: true,
        items: [this.value],
        theme: "bootstrap",
        placeholder: this.placeholder,
        valueField: this.valueField,
        labelField: this.labelField,
        searchField: [this.valueField, this.codeField, this.labelField],
        width: "100%"
      };

      if (this.minLength) {
        options.minimumInputLength = this.minLength;
      }

      if (this.codeField) {
        options.sortField = this.codeField;
      }

      if (this.options) {
        options.data = this.options.map(function(option) {
          option.id = option[vm.valueField];
          option.text = option[vm.labelField];

          return option;
        });
      }


      if (this.url && !this.minLength) {
        options["onInitialize"] = function() {
          var self = this;
          var fn = self.settings.load;
          self.load(function(callback) {
            fn.apply(self, ["", callback]);
          });
        };

        options.onLoad = function(data) {
          if (vm.url && !vm.minLength && vm.value && !vm.firstLoadSelected) {
            $(vm.$el)[0].selectize.setValue(vm.value.toString());
            vm.firstLoadSelected = true;
          }
        };
      }

      if (this.url) {
        options.ajax = {
          url: vm.url,
          data: function (params) {
            var query = {
              q: params.term,
              start_date: vm.start_date,
              end_date: vm.end_date
            };

            if (vm.drilldownName && vm.drilldownValue) {
              query[vm.drilldownName] = vm.drilldownValue;
            }

            return query;
          },
          dataType: 'json',
          processResults: function (data, params) {
            return {
              results: data.map(function(item) {
                item.id = item[vm.valueField];
                item.text = item[vm.labelField];

                return item;
              })
            };
          },
          cache: false
        };

        // options["load"] = function(query, callback) {
        //   vm.$el.selectize.clearOptions();
        //   vm.$el.selectize.clearCache();
        //   vm.$el.selectize.refreshOptions();
        //   vm.$el.selectize.renderCache['option'] = {};
        //   vm.$el.selectize.renderCache['item'] = {};

        //   if (vm.drilldownRequired === "true" && !vm.drilldownValue) return callback();

        //   var data = {
        //     q: query,
        //     start_date: vm.start_date,
        //     end_date: vm.end_date
        //   };

        //   if (vm.drilldownName && vm.drilldownValue) {
        //     data[vm.drilldownName] = vm.drilldownValue;
        //   }

        //   $.ajax({
        //     url: vm.url,
        //     data: data,
        //     type: 'GET',
        //     error: function() {
        //       callback();
        //     },
        //     success: function(res) {
        //       callback(res);
        //     }
        //   });
        // }
      }

      var codeField = this.codeField;

      if (codeField) {
        options.templateSelection = function(state) {
          if (!state.id) {
            return state.text;
          }

          return $("<div class='item'>" + state[codeField] + " - " + state[options.labelField] + "</div>");
        };

        options.templateResult = function(state) {
          if (!state.id) {
            return state.text;
          }

          return $("<span class='selection" + (state.disabled ? ' selection--strikethrough' : '') + "'><span class='option-prefix option-prefix--series'>" + state[codeField] + "</span> " + state[options.labelField] + "</span>");
        };
      }

      $(this.$el).select2(options).val(this.value).trigger('change').on('change', function () {
        console.log(this.value);
        vm.$emit('input', this.value);
      });

      if (this.dateSensitive) {
        this.handleDateSentitivity = function(event, start_date, end_date) {
          vm.start_date = start_date;
          vm.end_date = end_date;

          $(vm.$el).empty();

          $(vm.$el).val(null).trigger('change.select2');
        };

        $(".measure-form").on("dates:changed", this.handleDateSentitivity);
      }
    },
    watch: {
      value: function (value) {
        $(this.$el).val(value);
        $(this.$el).trigger("change");
      },
      options: function (options) {
        var self = this;
        $(this.$el).empty();

        options.forEach(function(option) {
          option.id = option[self.valueField];
          option.text = option[self.labelField];

          return option;
        });

        $(this.$el).select2({ data: options });
      },
      drilldownValue: function(newVal, oldVal) {
        if (newVal == oldVal) {
          return;
        }

        this.handleDateSentitivity({}, this.start_date, this.end_date);
      }
    },
    destroyed: function () {
      $(this.$el).select2("destroy");

      if (this.dateSensitive) {
        $(".measure-form").off("dates:changed", this.handleDateSentitivity);
      }
    }
  });

  Vue.component('quota-period', {
    template: "#quota-period-template",
    props: ["quotaPeriod", "index"],
    data: function() {
      return {
        quotaOptions: [
          { value: "annual", label: "Annual" },
          { value: "bi_annual", label: "Bi-Annual" },
          { value: "quarterly", label: "Quarterly" },
          { value: "monthly", label: "Monthly" },
          { value: "custom", label: "Custom" }
        ]
      }
    },
    computed: {
      isAnnual: function() {
        return this.quotaPeriod.type === "annual";
      },
      isQuarterly: function() {
        return this.quotaPeriod.type === "quarterly";
      },
      isBiAnnual: function() {
        return this.quotaPeriod.type === "bi_annual";
      },
      isMonthly: function() {
        return this.quotaPeriod.type === "monthly";
      },
      isCustom: function() {
        return this.quotaPeriod.type === "custom";
      },
      isAnnualOrCustom: function() {
        return this.isCustom || this.isAnnual;
      },
      isFirst: function() {
        return this.index === 0;
      }
    }
  });

  Vue.component('date-select', {
    template: "#date-select-template",
    props: ["value", "minYear"],
    data: function() {
      return {
        vproxy: this.value
      }
    },
    mounted: function() {
      var self = this;

      new Pikaday({
        field: $(this.$el)[0],
        format: "DD/MM/YYYY",
        blurFieldOnSelect: true
      });

      $(this.$el).on("change", function() {
        self.vproxy = $(self.$el).val();
      });
    },
    watch: {
      vproxy: function() {
        this.$emit("update:value", this.vproxy);
      }
    }
  });

  var componentCommonFunctionality = {
    computed: {
      showDutyAmountOrPercentage: function() {
        var ids = ["01", "02", "04", "19", "20"];

        return ids.indexOf(this[this.thing].duty_expression_id) > -1;
      },
      showDutyAmountPercentage: function() {
        var ids = ["23"];

        return ids.indexOf(this[this.thing].duty_expression_id) > -1;
      },
      showDutyAmountNegativePercentage: function() {
        var ids = ["36"];

        return ids.indexOf(this[this.thing].duty_expression_id) > -1;
      },
      showDutyAmountNumber: function() {
        var ids = ["06", "07", "09", "11", "12", "13", "14", "21", "25", "27", "29", "31"];

        return ids.indexOf(this[this.thing].duty_expression_id) > -1;
      },
      showDutyAmountMinimum: function() {
        var ids = ["15"];

        return ids.indexOf(this[this.thing].duty_expression_id) > -1;
      },
      showDutyAmountMaximum: function() {
        var ids = ["17", "35"];

        return ids.indexOf(this[this.thing].duty_expression_id) > -1;
      },
      showDutyRefundAmount: function() {
        var ids = ["40", "41", "42", "43", "44"];

        return ids.indexOf(this[this.thing].duty_expression_id) > -1;
      },
      showMeasurementUnit: function() {
        var ids = ["23", "36", "37"];

        return this[this.thing].duty_expression_id && ids.indexOf(this[this.thing].duty_expression_id) === -1;
      }
    }
  };

  Vue.component("measure-component", $.extend({}, {
    template: "#measure-component-template",
    props: ["measureComponent"],
    data: function() {
      return {
        thing: "measureComponent"
      };
    }
  }, componentCommonFunctionality));

  Vue.component("measure-condition-component", $.extend({}, {
    template: "#measure-condition-component-template",
    props: ["measureConditionComponent"],
    data: function() {
      return {
        thing: "measureConditionComponent"
      };
    }
  }, componentCommonFunctionality));

  Vue.component("foot-note", {
    template: "#footnote-template",
    props: ["footnote"],
    data: function() {
      return {
        suggestions: [],
        lastSuggestionUsed: null
      };
    },
    computed: {
      hasSuggestions: function() {
        return this.suggestions.length > 0;
      }
    },
    mounted: function() {
      this.fetchSuggestions = debounce(this.fetchSuggestions.bind(this), 100, false);
    },
    methods: {
      fetchSuggestions: function() {
        var self = this;
        var type_id = this.footnote.footnote_type_id;
        var description =  this.footnote.description.trim();

        this.suggestions.splice(0, 999);

        if (description.length < 1) {
          return;
        }

        $.ajax({
          url: "/footnotes",
          data: {
            footnote_type_id: type_id,
            description: description
          },
          success: function(data) {
            self.suggestions = data;
          }
        });
      },
      useSuggestion: function(suggestion) {
        this.lastSuggestionUsed  = suggestion;
        this.footnote.description = suggestion.description;
        this.suggestions.splice(0, 999);
      }
    },
    watch: {
      "footnote.description": function(newVal, oldVal) {
        if (this.lastSuggestionUsed && newVal === this.lastSuggestionUsed.description) {
          return;
        }

        this.fetchSuggestions();
      }
    }
  });

  Vue.component('measure-condition', {
    template: "#condition-template",
    props: ["condition"],
    computed: {
      showAction: function() {
        var codes = ["K", "P", "S", "W", "Y"];

        return this.condition.condition_code && codes.indexOf(this.condition.condition_code) === -1;
      },
      showConditionComponents: function() {
        var codes = ["01", "02", "03", "11", "12", "13", "15", "27", "34", "36"];

        return codes.indexOf(this.condition.action_code) > -1;
      },
      showMinimumPrice: function() {
        var codes = ["F", "G", "L", "N"];

        return codes.indexOf(this.condition.condition_code) > -1;
      },
      showRatio: function() {
        var codes = ["R", "U"];

        return codes.indexOf(this.condition.condition_code) > -1;
      },
      showEntryPrice: function() {
        var codes = ["V"];

        return codes.indexOf(this.condition.condition_code) > -1;
      },
      showAmount: function() {
        var codes = ["E", "I", "M"];

        return codes.indexOf(this.condition.condition_code) > -1;
      },
      certificateActionHint: function() {
        var codes = ["A", "B", "C", "E", "I", "H", "Q", "Z"];

        return codes.indexOf(this.condition.condition_code) > -1;
      },
      noCertificateActionHint: function() {
        var codes = ["D", "F", "G", "L", "M", "N", "R", "U", "V"];

        return codes.indexOf(this.condition.condition_code) > -1;
      },
      showCertificateType: function() {
        var codes = ["B", "C", "E", "I", "H", "Q", "Z", "V", "E"];

        return codes.indexOf(this.condition.condition_code) > -1;
      },
      showCertificate: function() {
        var codes = ["A", "B", "C", "E", "I", "H", "Q", "Z", "V", "E"];

        return codes.indexOf(this.condition.condition_code) > -1;
      },
      showAddMoreCertificates: function() {
        var codes = ["A", "Z"];

        return codes.indexOf(this.condition.condition_code) > -1;
      },
      canRemoveComponent: function() {
        return this.condition.measure_condition_components.length > 1;
      }
    },
    watch: {
      showAction: function() {
        if (!this.showAction) {
          this.condition.action_code = null;
          this.condition.measure_condition_components = [{
            duty_expression_id: null,
            amount: null,
            measurement_unit_code: null,
            measurement_unit_qualifier_code: null
          }];
        }
      },
      "condition.certificate_type_id": function() {
        this.certificate_id = null;
      },
      showCertificateType: function(newVal, oldVal) {
        if (oldVal === false && newVal === true) {
          this.certificate_id = null;
        }
      }
    },
    methods: {
      addMeasureConditionComponent: function() {
        this.condition.measure_condition_components.push({
          duty_expression_id: null,
          amount: null,
          measurement_unit_code: null,
          measurement_unit_qualifier_code: null
        });
      },
      removeMeasureConditionComponent: function(measureConditionComponent) {
        var idx = this.condition.measure_condition_components.indexOf(measureConditionComponent);

        if (idx === -1) {
          return;
        }

        this.condition.measure_condition_components.splice(idx, 1);
      }
    }
  });

  var app = new Vue({
    el: form,
    data: function() {
      var data = {
        goods_nomenclature_code: "",
        additional_code: null,
        goods_nomenclature_code_description: "",
        additional_code_description: "",
        quota_statuses: [
          { value: "open", label: "Open" },
          { value: "exhausted", label: "Exhausted" },
          { value: "critical", label: "Critical" },
          { value: "unblocked", label: "Unblocked" },
          { value: "unsuspended", label: "Unsuspended" },
          { value: "reopened", label: "Reopened" }
        ],
        errors: []
      };

      if (window.__measure) {
        this.parseMeasure(window.__measure);
      } else {
        data.measure = {
          regulation_id: null,
          measure_type_series_id: null,
          measure_type_id: null,
          quota_ordernumber: null,
          quota_status: "open",
          quota_criticality_threshold: null,
          quota_description: null,
          geographical_area_id: null,
          excluded_geographical_areas: [],
          conditions: [],
          quota_periods: [],
          measure_components: [],
          footnotes: []
        };
      }

      return data;
    },
    mounted: function() {
      var self = this;

      if (this.measure.quota_periods.length === 0) {
        this.addQuotaPeriod(true);
      }

      if (this.measure.conditions.length === 0) {
        this.addCondition();
      }

      if (this.measure.footnotes.length === 0) {
        this.measure.footnotes.push({
          footnote_type_id: null,
          description: null
        });
      }

      if (this.measure.measure_components.length === 0) {
        this.measure.measure_components.push({
          duty_expression_id: null,
          amount: null,
          measurement_unit_code: null,
          measurement_unit_qualifier_code: null
        });
      }

      this.fetchNomenclatureCode("/goods_nomenclatures", 10, "goods_nomenclature_code", "goods_nomenclature_code_description");

      $("#measure_form_measure_type_series_id").on("change", function() {
        self.measure.measure_type_series_id = $("#measure_form_measure_type_series_id").val();
      });

      $("#measure_form_measure_type_id").on("change", function() {
        self.measure.measure_type_id = $("#measure_form_measure_type_id").val();
      });

      $(".measure-form").on("submit", function(e) {
        e.preventDefault();
        e.stopPropagation();

        var button = $("input[type='submit']");
        button.attr("data-text", button.val());
        button.val("Saving...");
        button.prop("disabled", true);

        self.errors = [];

        $.ajax({
          url: "/measures",
          type: "POST",
          data: {
            measure: self.preparePayload()
          },
          success: function(response) {
            $(".js-measure-form-errors-container").empty().addClass("hidden");
            window.location = "/measures?code=" + response.goods_nomenclature_item_id;
          },
          error: function(response) {
            //TODO: handle errors
            button.val(button.attr("data-text"));
            button.prop("disabled", false);

            $.each( response.responseJSON.errors, function( key, value ) {
              if (value.constructor === Array) {
                value.forEach(function(innerError) {
                  self.errors.push(innerError);
                });
              } else {
                self.errors.push(value);
              }
            });
          }
        });
      });

      $(".measure-form").on("geoarea:changed", function(e, id) {
        self.measure.geographical_area_id = id;
      });

      $(".measure-form").on("exclusions:changed", function(e, ids) {
        self.measure.excluded_geographical_areas = ids;
      });
    },
    methods: {
      parseMeasure: function(raw) {
        var actual = {
          measure_id: raw.measure_id,
          regulation_id: raw.regulation_id,
          measure_type_series_id: raw.measure_type_series_id,
          measure_type_id: raw.measure_type_id,
          quota_ordernumber: raw.quota_ordernumber,
          quota_status: raw.quota_status,
          quota_criticality_threshold: raw.quota_criticality_threshold,
          quota_description: raw.quota_description,
          geographical_area_id: raw.geographical_area_id,
          excluded_geographical_areas: raw.excluded_geographical_areas,
          conditions: [],
          quota_periods: [],
          measure_components: [],
          footnotes: raw.footnotes
        };


        return actual;
      },
      addCondition: function() {
        this.measure.conditions.push({
          id: null,
          action_code: null,
          certificate_type_id: null,
          certificate_id: null,
          measure_condition_components: [
            {
              duty_expression_id: null,
              amount: null,
              measurement_unit_code: null,
              measurement_unit_qualifier_code: null
            }
          ]
        });
      },
      addQuotaPeriod: function(first) {
        this.measure.quota_periods.push({
          type: first === true ? null : "custom",
          monthly: {
            amount1: null,
            amount2: null,
            amount3: null,
            amount4: null,
            amount5: null,
            amount6: null,
            amount7: null,
            amount8: null,
            amount9: null,
            amount10: null,
            amount11: null,
            amount12: null,
          },
          quarterly: {
            amount1: null,
            amount2: null,
            amount3: null,
            amount4: null
          },
          bi_annual: {
            amount1: null,
            amount2: null
          },
          annual: {
            amount1: null
          },
          custom: {
            amount1: null
          },
          start_date: null,
          end_date: null,
          measurement_unit_id: null,
          measurement_unit_qualifier_id: null
        });
      },
      addMeasureComponent: function() {
        this.measure.measure_components.push({
          duty_expression_id: null,
          amount: null,
          measurement_unit_code: null,
          measurement_unit_qualifier_code: null
        });
      },
      addFootnote: function() {
        this.measure.footnotes.push({
          footnote_type_id: null,
          description: null
        });
      },
      fetchNomenclatureCode: function(url, length, code, description, type, description_field) {
        var self = this;
        if (this[code].trim().length === length) {
          $.ajax({
            url: url,
            data: {
              q: this[code].trim()
            },
            success: function(data) {

              if (type === "json") {
                if (data.length > 0) {
                  self[description] = data[0][description_field];
                  self.measure[code] = self[code].trim();
                } else {
                  self[description] = "";
                  self.measure[code] = null;
                }
              } else {
                self[description] = data;
                self.measure[code] = self[code].trim();
              }

            },
            error: function() {
              self[description] = "";
              self.measure[code] = null;
            }
          });
        } else {
          self[description] = "";
          self.measure[code] = null;
        }
      },
      preparePayload: function() {
        var payload = {
          start_date: this.measure.validity_start_date,
          end_date: this.measure.validity_end_date,
          regulation_id: this.measure.regulation_id,
          measure_type_series_id: this.measure.measure_type_series_id,
          measure_type_id: this.measure.measure_type_id,
          goods_nomenclature_code: this.measure.goods_nomenclature_code,
          additional_code: this.measure.additional_code,
          additional_code_type_id: this.measure.additional_code_type_id,
          goods_nomenclature_code_description: this.measure.goods_nomenclature_code_description,
          additional_code_description: this.measure.additional_code_description,

          measure_components: this.measure.measure_components,
          footnotes: this.measure.footnotes,
          conditions: this.measure.conditions,

          quota_status: this.measure.quota_status,
          quota_ordernumber: this.measure.quota_ordernumber,
          quota_criticality_threshold: this.measure.quota_criticality_threshold,
          quota_description: this.measure.quota_description,
          geographical_area_id: this.measure.geographical_area_id,
          excluded_geographical_areas: this.measure.excluded_geographical_areas
        };

        if (this.measure.quota_periods.length > 0 && this.measure.quota_periods[0].type) {
          var periodPayload = {};

          switch (this.measure.quota_periods[0].type) {
            case "custom":
              var t = this.measure.quota_periods[0].type;

              periodPayload[t] = this.measure.quota_periods.map(function(period) {
                return {
                  amount1: period.custom.amount1,
                  start_date: period.start_date,
                  end_date: period.end_date,
                  measurement_unit_code: period.measurement_unit_code,
                  measurement_unit_qualifier_code: period.measurement_unit_qualifier_code
                };
              });

              break;
            default:
              var t = this.measure.quota_periods[0].type;

              periodPayload[t] = this.measure.quota_periods[0][t];
              periodPayload[t].start_date = this.measure.quota_periods[0].start_date;
              periodPayload[t].end_date = this.measure.quota_periods[0].end_date;
              periodPayload[t].measurement_unit_code = this.measure.quota_periods[0].measurement_unit_code;
              periodPayload[t].measurement_unit_qualifier_code = this.measure.quota_periods[0].measurement_unit_qualifier_code;

              break;
          }

          payload.quota_periods = periodPayload;
        } else {
          payload.quota_periods = {};
        }

        return payload;
      },
      removeQuotaPeriod: function(quotaPeriod) {
        var index = this.measure.quota_periods.indexOf(quotaPeriod);

        if (index === -1) {
          return;
        }

        this.measure.quota_periods.splice(index, 1);
      },
      removeFootnote: function(footnote) {
        var index = this.measure.footnotes.indexOf(footnote);

        if (index === -1) {
          return;
        }

        this.measure.footnotes.splice(index, 1);
      },
      removeMeasureComponent: function(measureComponent) {
        var index = this.measure.measure_components.indexOf(measureComponent);

        if (index === -1) {
          return;
        }

        this.measure.measure_components.splice(index, 1);
      },
      removeCondition: function(condition) {
        var index = this.measure.conditions.indexOf(condition);

        if (index === -1) {
          return;
        }

        this.measure.conditions.splice(index, 1);
      }
    },
    computed: {
      showAddMoreQuotaPeriods: function() {
        if (this.measure.quota_periods.length <= 0) {
          return false;
        }

        return this.measure.quota_periods[0].type === "custom";
      },
      showDuties: function() {
        var series = ["A", "B", "M", "N"];

        return this.measure.measure_type_series_id && series.indexOf(this.measure.measure_type_series_id) === -1;
      },
      showQuota: function() {
        if (!this.measure.measure_type_series_id || !this.measure.measure_type_id ) {
          return false;
        }

        if (this.measure.measure_type_series_id == "N") {
          return true;
        }

        var ids = ["122", "123", "143", "144", "146", "147", "907"];

        if (this.measure.measure_type_series_id == "C" && ids.indexOf(this.measure.measure_type_id) > -1) {
          return true;
        }

        return false;
      },
      showStandardImportValue: function() {
        return this.measure.measure_type_id === "490";
      },
      showReferencePrice: function() {
        return this.measure.measure_type_id === "489";
      },
      showUnitPrice: function() {
        return this.measure.measure_type_id === "488";
      },
      atLeastOneCondition: function() {
        return this.measure.conditions.length > 0;
      },
      noCondition: function() {
        return this.measure.conditions.length === 0;
      },
      hasErrors: function() {
        return this.errors.length > 0;
      },
      canRemoveQuota: function() {
        return this.measure.quota_periods.length > 1;
      },
      canRemoveFootnote: function() {
        return this.measure.footnotes.length > 1;
      },
      canRemoveCondition: function() {
        return this.measure.conditions.length > 1;
      },
      canRemoveMeasureComponent: function() {
        return this.measure.measure_components.length > 1;
      }
    },
    watch: {
      showAddMoreQuotaPeriods: function() {
        if (!this.showAddMoreQuotaPeriods) {
          this.measure.quota_periods.splice(1, 200);
        }
      },
      goods_nomenclature_code: function() {
        this.fetchNomenclatureCode("/goods_nomenclatures", 10, "goods_nomenclature_code", "goods_nomenclature_code_description");
      },
      "measure.validity_start_date": function() {
        window.measure_start_date = this.measure.validity_start_date;
        $(".measure-form").trigger("dates:changed", [this.measure.validity_start_date, this.measure.validity_end_date]);
      },
      "measure.validity_end_date": function() {
        window.measure_end_date = this.measure.validity_end_date;
        $(".measure-form").trigger("dates:changed", [this.measure.validity_start_date, this.measure.validity_end_date]);
      },
      "measure.additional_code_type_id": function(newVal, oldVal) {
        if (oldVal && !newVal) {
          this.measure.additional_code = null;
        }
      }
    }
  });

  var findMeasureTypeById = function(id) {
    for (var k in window.measure_types_json) {
      if (!window.measure_types_json.hasOwnProperty(k)) {
        continue;
      }

      for (var i = 0; i < window.measure_types_json[k].length; i++) {
        var type = window.measure_types_json[k][i];

        if (type.measure_type_id == id) {
          return type;
        }
      }
    }

    return null;
  };

  var findMeasureTypeSeriesById = function(id) {
    for (var i = 0; i < window.measure_types_series_json.length; i++) {
      var type = window.measure_types_series_json[i];

      if (type.measure_type_series_id == id) {
        return type;
      }
    }

    return null;
  }

  var measureTypeSeries = null;

  function initializeMeasureTypeSeries(options) {
    var config = {
      theme: "bootstrap",
      placeholder: "― optionally filter by measure series ―",
      allowClear: true,
      templateSelection: function(state) {
        if (!state.id) {
          return state.text;
        }

        return $("<div class='item'>" + state.id + " - " + state.text + "(" + state.id + ")</div>");
      },
      templateResult: function(state) {
        if (!state.id) {
          return state.text;
        }

        return $("<span class='selection" + (state.disabled ? ' selection--strikethrough' : '') + "'><span class='option-prefix option-prefix--series'>" + state.id + "</span> " + state.text + "(" + state.id + ")</span>");
      }
    };

    if (options) {
      config.data = options;
      $("#measure_form_measure_type_series_id").empty();
      $("#measure_form_measure_type_series_id").append("<option value></option>");
    }

    measureTypeSeries = $("#measure_form_measure_type_series_id").select2(config);
  }

  var measureType = null;

  function initializeMeasureType(options) {
    var config = {
      theme: "bootstrap",
      placeholder: "― optionally filter by measure series ―",
      allowClear: true,
      templateSelection: function(state) {
        if (!state.id) {
          return state.text;
        }

        return $("<div class='item'>" + state.id + " - " + state.text + "(" + state.id + ")</div>");
      },
      templateResult: function(state) {
        if (!state.id) {
          return state.text;
        }

        return $("<span class='selection" + (state.disabled ? ' selection--strikethrough' : '') + "'><span class='option-prefix option-prefix--series'>" + state.id + "</span> " + state.text + "(" + state.id + ")</span>");
      }
    };

    if (options) {
      config.data = options;
      $("#measure_form_measure_type_id").empty();
      $("#measure_form_measure_type_id").append("<option value></option>");
    }

    measureType = $("#measure_form_measure_type_id").select2(config);
  }

  initializeMeasureTypeSeries();
  initializeMeasureType();

  $("#measure_form_measure_type_series_id").on("change", function() {
    var v = $("#measure_form_measure_type_series_id").val();

    initializeMeasureType(window.measure_types_json.filter(function(d) {
      return !v || (v && d.measure_type_series_id == v);
    }).map(function(option) {
      option.id = option.measure_type_id;
      option.text = option.description;

      return option;
    }));
  });

  $(".measure-form").on("dates:changed", function(event, start_date, end_date) {
    $("#measure_form_measure_type_id").val("");
    $("#measure_form_measure_type_id").trigger("change");

    $("#measure_form_measure_type_series_id").val("");
    $("#measure_form_measure_type_series_id").trigger("change");

    $.ajax({
      url: "/measure_types",
      data: {
        start_date: start_date,
        end_date: end_date
      },
      success: function(data) {
        window.measure_types_json = data;
        measureType.empty();
        initializeMeasureType(data.map(function(option) {
          option.id = option.measure_type_id;
          option.text = option.description;

          return option;
        }));
      }
    });

    $.ajax({
      url: "/measure_type_series",
      data: {
        start_date: start_date,
        end_date: end_date
      },
      success: function(data) {
        window.measure_types_series_json = data;
        initializeMeasureTypeSeries(data.map(function(option) {
          option.id = option.measure_type_series_id;
          option.text = option.description;

          return option;
        }));
      }
    });
  });

  var origins = [];

  var handleOnSelect = function(obj) {
    origins.forEach(function(origin) {
      if (origin !== obj) {
        origin.deselect();
      }
    });

    $(".measure-form").trigger("geoarea:changed", [obj.geographical_area_id]);
    $(".measure-form").trigger("exclusions:changed", [[]]);

    $("#measure_form_excluded_geographical_areas").val([]);
  };

  var handleUpdate = function(ids) {
    $("#measure_form_excluded_geographical_areas").val(ids);
    $(".measure-form").trigger("exclusions:changed", [ids]);
  };

  $(".origins-region .multiple-choice").each(function() {
    var origin = new Origin($(this));
    origin.onSelect = handleOnSelect;
    origin.onExclusionsUpdate = handleUpdate;

    origins.push(origin);
  });
});
