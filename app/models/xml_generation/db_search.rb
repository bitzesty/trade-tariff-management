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

    def initialize(date_filters)
      @start_date = date_filters[:start_date].strftime("%Y-%m-%d")
      @end_date = date_filters[:end_date].strftime("%Y-%m-%d") if date_filters[:end_date].present?
    end

    def result
      data
    end

  private

    def data
      [Measure].map do |entity|
        "#{entity}::Operation".constantize.where(where_clause).all
      end.flatten
    end

    def where_clause
      if end_date.present?
        ['? <= operation_date AND operation_date <= ? AND national = ?', start_date, end_date, true]
      else
        ['operation_date >= ? AND national = ?', start_date, true]
      end
    end
  end
end
