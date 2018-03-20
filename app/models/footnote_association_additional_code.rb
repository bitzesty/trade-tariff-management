class FootnoteAssociationAdditionalCode < Sequel::Model

  include ::XmlGeneration::BaseHelper

  plugin :oplog, primary_key: [:footnote_id,
                               :footnote_type_id,
                               :additional_code_sid]
  plugin :conformance_validator
  set_primary_key [:footnote_id, :footnote_type_id, :additional_code_sid]
end


