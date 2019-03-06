module XmlGeneration
  class DBSearch
    EXPORT_MODELS = [
        GeographicalArea,
        GeographicalAreaDescription,
        GeographicalAreaDescriptionPeriod,
        GeographicalAreaMembership,
        MonetaryUnit,
        MonetaryUnitDescription,
        MonetaryExchangePeriod,
        MonetaryExchangeRate,
        MeasurementUnitQualifier,
        MeasurementUnitQualifierDescription,
        MeasurementUnit,
        MeasurementUnitDescription,
        Measurement,
        QuotaOrderNumber,
        QuotaOrderNumberOrigin,
        QuotaOrderNumberOriginExclusion,
        QuotaDefinition,
        QuotaAssociation,
        QuotaReopeningEvent,
        QuotaUnsuspensionEvent,
        QuotaUnblockingEvent,
        QuotaBalanceEvent,
        QuotaCriticalEvent,
        QuotaExhaustionEvent,
        QuotaSuspensionPeriod,
        QuotaBlockingPeriod,
        GoodsNomenclatureGroup,
        GoodsNomenclatureGroupDescription,
        GoodsNomenclature,
        GoodsNomenclatureDescription,
        GoodsNomenclatureDescriptionPeriod,
        GoodsNomenclatureIndent,
        GoodsNomenclatureOrigin,
        GoodsNomenclatureSuccessor,
        NomenclatureGroupMembership,
        MeasureTypeSeries,
        MeasureTypeSeriesDescription,
        MeasureType,
        MeasureTypeDescription,
        MeasureAction,
        MeasureActionDescription,
        Measure,
        MeasureComponent,
        MeasureConditionCode,
        MeasureConditionCodeDescription,
        MeasureCondition,
        MeasureConditionComponent,
        MeasurePartialTemporaryStop,
        MeasureExcludedGeographicalArea,
        AdditionalCodeType,
        AdditionalCodeTypeDescription,
        AdditionalCodeTypeMeasureType,
        AdditionalCode,
        AdditionalCodeDescription,
        AdditionalCodeDescriptionPeriod,
        MeursingAdditionalCode,
        MeursingTablePlan,
        MeursingTableCellComponent,
        MeursingHeading,
        MeursingHeadingText,
        MeursingSubheading,
        DutyExpression,
        DutyExpressionDescription,
        CertificateType,
        CertificateTypeDescription,
        Certificate,
        CertificateDescription,
        CertificateDescriptionPeriod,
        RegulationRoleType,
        RegulationRoleTypeDescription,
        RegulationReplacement,
        RegulationGroup,
        RegulationGroupDescription,
        BaseRegulation,
        ModificationRegulation,
        CompleteAbrogationRegulation,
        ExplicitAbrogationRegulation,
        FullTemporaryStopRegulation,
        FtsRegulationAction,
        ProrogationRegulation,
        ProrogationRegulationAction,
        FootnoteType,
        FootnoteTypeDescription,
        Footnote,
        FootnoteDescription,
        FootnoteDescriptionPeriod,
        FootnoteAssociationAdditionalCode,
        FootnoteAssociationGoodsNomenclature,
        FootnoteAssociationMeasure,
        FootnoteAssociationMeursingHeading,
        FootnoteAssociationErn,
        ExportRefundNomenclature,
        ExportRefundNomenclatureDescription,
        ExportRefundNomenclatureDescriptionPeriod,
        ExportRefundNomenclatureIndent,
        Language,
        LanguageDescription,
        TransmissionComment,
        PublicationSigle,
    ].freeze

    attr_accessor :start_date,
                  :end_date

    def initialize
      @start_date = '2018-07-18'
      @end_date = '2019-02-02'
    end

    def result
      data
    end

  private

    def data
      [
        MonetaryExchangePeriod,
        MonetaryExchangeRate,
        Measure,
        MeasureTypeSeries,
        MeasureTypeSeriesDescription,
        MeasureType,
        MeasureTypeDescription,
        MeasureAction,
        MeasureActionDescription,
        MeasureComponent,
        MeasureConditionCode,
        MeasureConditionCodeDescription,
        MeasureCondition,
        MeasureConditionComponent,
        MeasureExcludedGeographicalArea,
        DutyExpression,
        MeasurementUnit,
        MonetaryUnit,
        MeasurementUnitQualifier,
        Certificate,
        CertificateType
      ].map do |entity|
        "#{entity}::Operation".constantize.where(where_clause(entity)).all
      end.flatten
    end

    def where_clause(klass)
      # all records with negative measure_sid are national
      # operation_date is blank for old records, but we also need to export them
      if klass.columns.include?(:measure_sid)
        ['(operation_date <= ? OR operation_date IS NULL) AND measure_sid < 0', end_date]
      else
        ['operation_date <= ? OR operation_date IS NULL', end_date]
      end

      # if end_date.present?
      #   if klass.columns.include?(:measure_sid)
      #     ['? <= operation_date AND operation_date <= ? AND measure_sid < 0', start_date, end_date]
      #   else
      #     ['? <= operation_date AND operation_date <= ?', start_date, end_date]
      #   end
      # else
      #   if klass.columns.include?(:measure_sid)
      #     ['operation_date >= ? AND measure_sid < 0', start_date]
      #   else
      #     ['operation_date >= ?', start_date]
      #   end
      # end
    end
  end
end
