class FootnoteAssociationMeasureValidator < TradeTariffBackend::Validator
  validation :ME69, "The associated footnote must exist." do |record|
    if record.footnote_type_id.present? || record.footnote_id.present?
      record.footnote.present?
    end
  end

  validation :ME70, "The same footnote can only be associated once with the same measure." do |record|
    FootnoteAssociationMeasure.where(
      measure_sid: record.measure_sid,
      footnote_type_id: record.footnote_type_id,
      footnote_id: record.footnote_id,
    ).empty?
  end
end