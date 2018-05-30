require "rails_helper"

describe "Measure search: valid_to filter" do

  include_context "measures_search_base_context"
  include_context "measures_date_universal_context"

  let(:search_key) { "valid_to" }
  let(:field_name) { "validity_end_date" }
end
