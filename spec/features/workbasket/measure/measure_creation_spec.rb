require "rails_helper"

RSpec.describe "adding measures", :js do
  it "allows news measures to be created and cross-checked" do
    create(:geographical_area, :erga_omnes)
    regulation = create(
      :base_regulation,
      :not_replaced,
      base_regulation_id: "D0399990",
      information_text: "Test regulation",
    )
    measure_type_series = create(:measure_type_series, :with_description)
    measure_type = create(
      :measure_type,
      measure_type_series: measure_type_series,
    )
    commodity = create(:commodity, :declarable)
    create(:user)

    visit(root_path)

    click_on("Create measures")

    input_date("When will these measures come into force?", Date.today)

    within(find("fieldset", text: "Which regulation gives legal force")) do
      search_for_value(type_value: "test", select_value: regulation.information_text)
    end

    select_measure_type_series(measure_type_series)
    select_measure_type(measure_type)

    workbasket_name = "create-measure-wb"
    fill_in("What is the name of this workbasket?", with: workbasket_name)
    fill_in("Goods commodity codes", with: commodity.goods_nomenclature_item_id)

    select_radio("Erga Omnes")
    click_on("Continue")

    expect(page).to have_content "Specify duties, conditions and footnotes"

    click_on("Continue")

    expect(page).to have_content "Review and submit"

    click_on("Submit for cross-check")

    expect(page).to have_content "Measures submitted"

    click_on("Return to main menu")

    within(find("tr", text: workbasket_name)) do
      click_on("Review for cross-check")
    end

    expect(page).to have_content "Cross-check and create measures"

    select_radio("I confirm that I have checked the above details")
    click_on("Finish cross-check")

    expect(page).to have_content "Measures cross-checked"
  end

  private

  def select_measure_type_series(measure_type_series)
    within(".workbasket_forms_create_measures_form_measure_type_series_id") do
      select_dropdown_value(measure_type_series.description)
    end
  end

  def select_measure_type(measure_type)
    within(".workbasket_forms_create_measures_form_measure_type_id") do
      select_dropdown_value(measure_type.description)
    end
  end
end
