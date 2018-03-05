transmission.tag!("oub:measure") do |measure|
  record.tag!("oub:measure.sid") do measure
    xml_data_item(measure, self.measure_sid)
  end

  record.tag!("oub:measure.type") do measure
    xml_data_item(measure, self.measure_type_id)
  end

  record.tag!("oub:validity.start.date") do measure
    xml_data_item(measure, self.validity_start_date.strftime("%Y-%m-%d") || '')
  end

  record.tag!("oub:validity.end.date") do measure
    xml_data_item(measure, self.validity_end_date.try(:strftime, "%Y-%m-%d") || '')
  end

  record.tag!("oub:geographical.area") do measure
    xml_data_item(measure, self.geographical_area_id)
  end

  record.tag!("oub:geographical.area.sid") do measure
    xml_data_item(measure, self.geographical_area_sid)
  end

  record.tag!("oub:goods.nomenclature.item.id") do measure
    xml_data_item(measure, self.goods_nomenclature_item_id)
  end

  record.tag!("oub:goods.nomenclature.sid") do measure
    xml_data_item(measure, self.goods_nomenclature_sid)
  end

  record.tag!("oub:additional.code") do measure
    xml_data_item(measure, self.additional_code_id)
  end

  record.tag!("oub:additional.code.type") do measure
    xml_data_item(measure, self.additional_code_type_id)
  end

  record.tag!("oub:measure.generating.regulation.role") do measure
    xml_data_item(measure, self.measure_generating_regulation_role)
  end

  record.tag!("oub:measure.generating.regulation.id") do measure
    xml_data_item(measure, self.measure_generating_regulation_id)
  end

  record.tag!("oub:justification.regulation.role") do measure
    xml_data_item(measure, self.justification_regulation_role)
  end

  record.tag!("oub:justification.regulation.id") do measure
    xml_data_item(measure, self.justification_regulation_id)
  end

  record.tag!("oub:stopped.flag") do measure
    xml_data_item(measure, "0")
  end
end
