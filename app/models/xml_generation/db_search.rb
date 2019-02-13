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
      [MonetaryExchangePeriod, MonetaryExchangeRate, Measure].map do |entity|
        "#{entity}::Operation".constantize.where(where_clause(entity)).all
      end.flatten
    end

    def where_clause(klass)
      if end_date.present?
        if klass.columns.include?(:national)
          ['? <= operation_date AND operation_date <= ? AND national = ?', start_date, end_date, true]
        else
          ['? <= operation_date AND operation_date <= ?', start_date, end_date]
        end
      else
        if klass.columns.include?(:national)
          ['operation_date >= ? AND national = ?', start_date, true]
        else
          ['operation_date >= ?', start_date]
        end
      end
    end
  end
end
