FactoryGirl.define do
  sequence(:regulation_number) {
    %w(C D A I J R).sample +
        Forgery(:basic).number(at_least: 10, at_most: 19).to_s +
        Forgery(:basic).number(at_least: 1000, at_most: 9999).to_s +
        Forgery(:basic).number(at_least: 0, at_most: 9).to_s
  }

  sequence(:regulation_role) {
    Forgery(:basic).number(at_least: 1, at_most: 8)
  }

  sequence(:regulation_group_id) {
    Forgery(:basic).text(exactly: 3, allow_numeric: false, allow_lower: false)
  }

  factory :base_regulation do
    base_regulation_id   { generate(:regulation_number) }
    base_regulation_role { 1 }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }
    effective_end_date  { nil }

    trait :abrogated do
      after(:build) { |br, evaluator|
        FactoryGirl.create(:complete_abrogation_regulation, complete_abrogation_regulation_id: br.base_regulation_id,
                                                            complete_abrogation_regulation_role: br.base_regulation_role)
      }
    end

    trait :xml do
      published_date                       { Date.today.ago(3.years) }
      validity_end_date                    { Date.today.ago(1.years) }
      effective_end_date                   { Date.today.ago(2.years) }
      community_code                       1
      regulation_group_id                  { generate(:regulation_group_id) }
      antidumping_regulation_role          { generate(:regulation_role) }
      related_antidumping_regulation_id    { generate(:regulation_number) }
      complete_abrogation_regulation_role  { generate(:regulation_role) }
      complete_abrogation_regulation_id    { generate(:regulation_number) }
      explicit_abrogation_regulation_role  { generate(:regulation_role) }
      explicit_abrogation_regulation_id    { generate(:regulation_number) }
      stopped_flag                         1
      officialjournal_number               "L 120"
      officialjournal_page                 13
      replacement_indicator                0
      information_text                     "TR"
      approved_flag                        true
      operation_date                       { Date.today }
    end
  end
end
