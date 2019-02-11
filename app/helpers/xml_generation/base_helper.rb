module XmlGeneration
  module BaseHelper
    ADDITIONAL_CODE_MAPPING = {

    }.freeze

    def timestamp_value(datetime)
      datetime.present? ? datetime.utc : ""
    end

    def xml_data_item(xml_node, data)
      xml_node.text!(data.to_s)
    end

    def xml_data_item_v2(xml_node, namespace, data)
      if data.in?([true, false]) || data.present?
        xml_node.tag!("oub:#{namespace}") do
          xml_node
          xml_data_item(xml_node, data)
        end
      end
    end

    def flag_format(val)
      val.present? ? 1 : 0
    end

    def measure_type_format(measure)
      if measure.measure_type_id == 'VTS'
        305
      elsif  measure.measure_type_id == 'VTZ'
        305
      elsif measure.excise?
        306
      else
        measure.measure_type_id
      end
    end

    def additional_code_type_format(measure)
      if  measure.measure_type_id == 'VTZ'
        'V'
      elsif measure.excise?
        'X'
      else
        measure.additional_code_type_id
      end
    end

    def additional_code_format(measure)
      if  measure.measure_type_id == 'VTZ'
        'ATZ'
      else
        measure.additional_code_id
      end
    end
  end
end
