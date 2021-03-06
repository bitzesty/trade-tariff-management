require "rails_helper"

RSpec.describe "adding geographical areas", :js do
  it "allows a new group to be created" do

    visit(root_path)

    click_on("Create a new geographical area")

    select_radio("A group")
    fill_in("What code will identify this area?", with: "EU27")
    fill_in("What is the area description?", with: "A description")
    input_date_gds("#validity_start_date", 3.days.from_now)

    click_on "Submit for approval"

    expect(page).to have_content "Geographical area submitted"
  end

  it "allows a new country to be created" do
    create(:geographical_area, :erga_omnes)
    create(:geographical_area, :third_countries)
    group = create(:geographical_area, :group, geographical_area_id: "9999")

    visit(root_path)

    click_on("Create a new geographical area")

    select_radio("A country")
    fill_in("What code will identify this area?", with: "GE")
    fill_in("What is the area description?", with: "A description")
    input_date_gds("#validity_start_date", 3.days.from_now)

    click_on("Add memberships")

    within(".modal") do
      select_dropdown_value(group.geographical_area_id)
      click_on("Add memberships")
    end

    expect(area_membership_codes).to include group.geographical_area_id

    click_on "Submit for approval"

    expect(page).to have_content "Geographical area submitted"
    expect_to_be_a_member(group)
  end

  it "allows a new group to be created" do
    create(:geographical_area, :erga_omnes)
    create(:geographical_area, :third_countries)
    country = create(:geographical_area, :country, geographical_area_id: 'XX')

    visit(root_path)

    click_on("Create a new geographical area")

    select_radio("A group")
    fill_in("What code will identify this area?", with: "0000")
    fill_in("What is the area description?", with: "A description")
    input_date_gds("#validity_start_date", 3.days.from_now)

    click_on("Add memberships")

    within("#modal-1") do
      find("#country_codes_text").set("XX")
      click_on("Add memberships")
    end

    expect(area_membership_codes).to include "XX"

    click_on "Submit for approval"

    expect(page).to have_content "Geographical area submitted"
    expect_to_have_member(country)
  end

  it "allows user to remove default groups from new country" do
    erga_omnes = create(:geographical_area, :erga_omnes)
    third_countries = create(:geographical_area, :third_countries)

    visit(root_path)

    click_on("Create a new geographical area")

    select_radio("A country")
    fill_in("What code will identify this area?", with: "GE")
    fill_in("What is the area description?", with: "A description")
    input_date_gds("#validity_start_date", 3.days.from_now)

    expect(page).to have_content("1008")

    all("#remove-group").last.click

    within("#modal-1") do
      expect(page).to have_content "You are going to delete membership!"
      click_on("Confirm")
    end

    expect(page).to_not have_content("1008")

    click_on "Submit for approval"

    expect(page).to have_content "Geographical area submitted"
    expect_to_not_be_a_member(third_countries)
    expect_to_be_a_member(erga_omnes)
  end

  private

  def expect_to_be_a_member(group)
    country = GeographicalArea.find(geographical_area_id: "GE")
    membership_sids = country.member_of_following_geographical_areas.map { |geo_area| geo_area.geographical_area_sid }
    membership_sids.include?(group.geographical_area_sid)
  end

  def expect_to_have_member(country)
    group = GeographicalArea.find(geographical_area_id: "0000")
    membership_sids = group.contained_geographical_areas.map { |geo_area| geo_area.geographical_area_sid }
    membership_sids.include?(country.geographical_area_sid)
  end

  def expect_to_not_be_a_member(group)
    country = GeographicalArea.find(geographical_area_id: "GE")
    membership_sids = country.member_of_following_geographical_areas.map { |geo_area| geo_area.geographical_area_sid }
    membership_sids.include?(country.geographical_area_sid)
  end

  def area_membership_codes
    memberships_table.all("tbody tr td:first-of-type").map(&:text)
  end

  def memberships_table
    find("fieldset", text: "Configure memberships").find("table")
  end
end
