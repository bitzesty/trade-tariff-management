module Workbaskets
  class CreateMeasureTypeSettings < Sequel::Model(:create_measures_workbasket_settings)
    include ::WorkbasketHelpers::SettingsBase

    def collection_models
      %w(
        MeasureType
        MeasureTypeDescription
      )
    end

    def settings
      JSON.parse(main_step_settings_jsonb)
    end

    def measure_sids_jsonb
      '{}'
    end
  end
end
