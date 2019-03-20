class CreateMeasurePageElements < SitePrism::Page

  element :find_edit_existing_measures_link, ".heading-large a"
  element :measure_validity_start_date, "#measure_validity_start_date"
  element :measure_validity_end_date, :xpath, "//form/fieldset[2]//input"
  element :regulation_dropdown, "#wrapper fieldset:nth-child(6) .selectize-control input"
  elements :regulations_options, ".selectize-dropdown-content .option"
  element :workbasket_name, "#workbasket_name"
  element :commodity_code, "#commodity_codes"
  element :exceptions, "#exceptions"
  element :additional_codes, :xpath, "//form/fieldset[7]//textarea"
  element :reduction_indicator, "input.single-digit-field"
  element :erga_omnes_radio_button, ".origins-region #measure-origin-erga_omnes"
  element :country_groups_radio_button, ".origins-region #measure-origin-group"
  element :country_region_radio_button, ".origins-region #measure-origin-country"
  element :footnote_text_field, "#footnote-0-footnote"
  element :footnote_text_suggestion, "#footnote-0-suggestion-0-use-button"
  element :add_footnote_link, "div.footnote .selectize-input input"
  element :save_button, "input[name='save_progress']"
  element :continue_button, "input[name='continue']"
  element :exit_link, "a.js-workbasket-base-exit-button"
  element :previous_step_link, "a[class$='previous-step-link']"
  element :submit_for_crosscheck_button, "input[name='submit_for_cross_check']"

  section :conditions, "#wrapper fieldset:nth-child(5)" do
    element :duty_amount, "#measure-condition-0-measure-condition-component-0-amount"
  end

  section :duty_expressions, "#wrapper fieldset:nth-child(4) .measure-components" do
    element :add_duty_expression_link, "a"
    element :duty_amount, "#measure-component-0-amount"
  end

  section :measure_summary, '.create-measures-details-table' do
    element :workbasket_name, "tr:nth-child(1) td:nth-child(2)"
    element :operation_date, "tr:nth-child(2) td:nth-child(2)"
    element :regulation, "tr:nth-child(3) td:nth-child(2)"
    element :start_date, "tr:nth-child(4) td:nth-child(2)"
    element :end_date, "tr:nth-child(5) td:nth-child(2)"
    element :type, "tr:nth-child(6) td:nth-child(2)"
    element :goods, "tr:nth-child(7) td:nth-child(2)"
    element :goods_exceptions, "tr:nth-child(8) td:nth-child(2)"
    element :additional_codes, "tr:nth-child(9) td:nth-child(2)"
    element :origin, "tr:nth-child(10) td:nth-child(2)"
    element :origin_exceptions, "tr:nth-child(11) td:nth-child(2)"
  end

  section :measures_to_be_created, '.records-table .item-container' do
    elements :commodity_codes, ".goods_nomenclature-column"
    elements :additional_codes, ".additional_code-column"
    elements :start_date, ".validity_start_date-column"
    elements :end_date, ".validity_end_date-column"
    elements :duties, ".duties-column"
    elements :conditions, ".conditions-column"
    elements :footnotes, ".footnotes-column"
  end

  section :confirm_submission, '.panel--confirmation' do
    element :header, "h1", text: "Measures submitted"
    element :message, "h3"
  end

  section :error_summary, "div.js-custom-errors-block" do
    elements :errors, "li div"
  end
end