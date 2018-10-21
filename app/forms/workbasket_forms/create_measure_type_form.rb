module WorkbasketForms
  class CreateMeasureTypeForm
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :measure_type_series_id,
                  :measure_type_id,
                  :description,
                  :operation_date,
                  :validity_start_date,
                  :validity_end_date


    def measure_type_series_list
      MeasureTypeSeries.actual.map do |mts|
        {
          measure_type_series_id: mts.measure_type_series_id,
          description: mts.description
        }
      end.sort do |a, b|
        a[:measure_type_series_id] <=> b[:measure_type_series_id]
      end
    end
  end
end
