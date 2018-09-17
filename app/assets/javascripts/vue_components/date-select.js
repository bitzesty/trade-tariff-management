Vue.component('date-select', {
  template: "#date-select-template",
  props: ["value", "disabled"],
  data: function() {
    return {
      vproxy: this.value
    }
  },
  mounted: function() {
    var self = this;

    new Pikaday({
      showTime: false,
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
