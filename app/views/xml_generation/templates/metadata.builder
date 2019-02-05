xml.instruct!(:xml, version: "1.0", encoding: "utf-8")
xml.tag!("BatchFileInterfaceMetadata", xmlns: "http://www.hmrc.gsi.gov.uk/mdg/batchFileInterfaceMetadataSchema",
                                       "xmlns:vc" => "http://www.w3.org/2007/XMLSchema-versioning",
                                       "xsi:schemaLocation" => "http://www.hmrc.gsi.gov.uk/mdg/batchFileInterfaceMetadataSchema schema.xsd",
                                       "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance") do |env|
  env.tag!("sourceSystem") do |record|
    xml_data_item(record, self.class::SOURCE_SYSTEM)
  end

  env.tag!("sourceSystemType") do |record|
    xml_data_item(record, self.class::SOURCE_SYSTEM_TYPE)
  end

  env.tag!("sourceSystemOS") do |record|
    xml_data_item(record, self.class::SOURCE_SYSTEM_OS)
  end

  env.tag!("interfaceName") do |record|
    xml_data_item(record, self.class::INTERFACE_NAME)
  end

  env.tag!("interfaceVersion") do |record|
    xml_data_item(record, self.class::INTERFACE_VERSION)
  end

  env.tag!("correlationID") do |record|
    xml_data_item(record, self.correlation_id)
  end

  env.tag!("conversationID") do |record|
    xml_data_item(record, self.class::CONVERSATION_ID)
  end

  env.tag!("transactionID") do |record|
    xml_data_item(record, self.class::TRANSACTION_ID)
  end

  env.tag!("messageID") do |record|
    xml_data_item(record, self.class::MESSAGE_ID)
  end

  env.tag!("extractStartDateTime") do |record|
    xml_data_item(record, self.extract_start_date_time)
  end

  env.tag!("extractEndDateTime") do |record|
    xml_data_item(record, self.extract_end_date_time)
  end

  env.tag!("extractDatabaseDateTime") do |record|
    xml_data_item(record, self.extract_database_date_time)
  end

  env.tag!("checksum") do |record|
    xml_data_item(record, self.xml_file_checksum)
  end

  env.tag!("checksumAlgorithm") do |record|
    xml_data_item(record, self.class::CHECKSUM_ALGORITHM)
  end

  env.tag!("fileSize") do |record|
    xml_data_item(record, self.xml_file_size)
  end

  env.tag!("sourceLocation") do |record|
    xml_data_item(record, self.class::SOURCE_LOCATION)
  end

  env.tag!("sourceFileName") do |record|
    xml_data_item(record, self.source_file_name)
  end

  env.tag!("sourceFileEncoding") do |record|
    xml_data_item(record, self.class::SOURCE_FILE_ENCODING)
  end

  env.tag!("destinations") do |destinations_node|
    self.destinations.map do |destination|
      destinations_node.tag!("destination") do |destination_node|
        destination_node.tag!("destinationSystem") do |record|
          xml_data_item(record, destination.destination_system)
        end

        destination_node.tag!("destinationLocation") do |record|
          xml_data_item(record, destination.destination_location)
        end

        destination_node.tag!("destinationFileName") do |record|
          xml_data_item(record, destination.destination_file_name)
        end

        destination_node.tag!("destinationFileEncoding") do |record|
          xml_data_item(record, destination.destination_file_encoding)
        end
      end
    end
  end
end
