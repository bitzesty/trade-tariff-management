FactoryGirl.define do
  factory :xml_export_file, class: ::XmlExport::File do
    issue_date { Date.today }
    date_filters { {start_date: issue_date } }
    # date_filters { "---\r\n:start_date: #{issue_date.strftime('%Y-%m-%d')}\r\n" }

    trait :workbasket do
      workbasket { true }
    end

    trait :database do
      workbasket { false }
    end
  end
end