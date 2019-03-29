class CreateQuotaPageElements < SitePrism::Page

  element :regulation_dropdown, "#wrapper fieldset:nth-child(4) .selectize-control input"
  elements :regulations_options, ".selectize-dropdown-content .option"
  element :quota_order_number, "input[name='quota_order_number']"
  element :quota_description, "#quota_description"
  element :operation_date, "#operation_date"
  element :commodity_code, "#commodity_codes"
  element :exceptions, "#exceptions"
  element :additional_codes, :xpath, "//form/fieldset[9]//textarea"
  element :reduction_indicator, ".single-digit-field"
  element :erga_omnes_radio_button, ".origins-region #measure-origin-erga_omnes"
  element :country_groups_radio_button, ".origins-region #measure-origin-group"
  element :country_region_radio_button, ".origins-region #measure-origin-country"
  element :licenced_quota_check_box, "#toggle-type"
  # element :licenced_quota_dropdown, ".workbasket_forms_create_quota_form_quota_licence"
  element :footnote_text_field, "#footnote-0-footnote"
  element :footnote_text_suggestion, "#footnote-0-suggestion-0-use-button"
  element :add_footnote_link, ""
  element :save_button, "input[name='save_progress']"
  element :continue_button, "input[name='continue']"
  element :exit_link, "a.js-workbasket-base-exit-button"
  element :previous_step_link, "a[class$='previous-step-link']"
  element :submit_for_crosscheck_button, "input[name='submit_for_cross_check']"

  section :quota_section, ".quota-section" do
    element :start_date, "#annual_start_date"
    element :section_staged_checkbox, "#period-0-staged"
    element :different_criticality_checkbox, ""
    element :different_duty_checkbox, "#period-0-duties_each_period"
    element :opening_balance, "#annual-opening-balance"
    element :start_quota_critical_checkbox, "#single-balance-critical"
    element :quota_criticality_threshold, ""
    element :duty_amount, "#quota-section-0-measure-component-0-amount"
  end

  section :conditions, "#wrapper fieldset:nth-child(4)" do
    element :duty_amount, "#measure-condition-0-measure-condition-component-0-amount"
  end

  section :quota_summary, '.create-measures-details-table' do
    element :order_number, "tr:nth-child(1) td:nth-child(2)"
    element :maximum_precision, "tr:nth-child(2) td:nth-child(2)"
    element :type, "tr:nth-child(3) td:nth-child(2)"
    element :operation_date, "tr:nth-child(4) td:nth-child(2)"
    element :licensed, "tr:nth-child(5) td:nth-child(2)"
    element :regulation, "tr:nth-child(6) td:nth-child(2)"
    element :goods, "tr:nth-child(7) td:nth-child(2)"
    element :goods_exceptions, "tr:nth-child(8) td:nth-child(2)"
    element :additional_codes, "tr:nth-child(9) td:nth-child(2)"
    element :origin, "tr:nth-child(10) td:nth-child(2)"
    element :origin_exceptions, "tr:nth-child(11) td:nth-child(2)"
    element :conditions, "tr:nth-child(12) td:nth-child(2)"
    element :footnotes, "tr:nth-child(13) td:nth-child(2)"
  end

  section :quotas_to_be_created, :xpath, '//div[@class="records-table-wrapper"][1]//*[@class="item-container"]' do
    elements :start_date, ".validity_start_date-column"
    elements :end_date, ".validity_end_date-column"
    elements :opening_balance, ".duties-column"
    elements :critical, ".conditions-column"
    elements :criticality_threshold, ".footnotes-column"
  end

  section :measures_to_be_created, :xpath, '//div[@class="records-table-wrapper"][2]//*[@class="item-container"]' do
    elements :start_date, ".validity_start_date-column"
    elements :end_date, ".validity_end_date-column"
    elements :commodity_codes, ".goods_nomenclature-column"
    elements :additional_codes, ".additional_code-column"
    elements :geographical_area, ".geographical_area-column"
    elements :duties, ".duties-column"
  end

  section :confirm_submission, '.panel--confirmation' do
    element :header, "h1", text: "Quota submitted"
    element :message, "h3"
  end
end