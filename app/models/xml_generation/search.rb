module XmlGeneration
  class Search

    SEQUENCE_OF_DATA_FETCH = [
      # MeasureType,
      # MeasureTypeDescription,
      Measure,
      # DutyExpression,
      # DutyExpressionDescription,
      # MeasureComponent,
      # MeasureConditionCode,
      # MeasureConditionCodeDescription,
      # MeasureCondition,
      # MeasureConditionComponent,
      # TransmissionComment
    ]

    attr_accessor :date

    def initialize(date)
      @date = date.strftime("%Y-%m-%d")
    end

    def result
      ::XmlGeneration::NodeEnvelope.new(
        SEQUENCE_OF_DATA_FETCH.map do |record_class|
          record_class.where("operation_date = ?", date).all
        end.flatten
      )
    end
  end
end
