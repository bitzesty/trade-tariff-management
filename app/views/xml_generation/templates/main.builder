xml.instruct!(:xml, version: "1.0", encoding: "utf-8")
xml.tag!("env:envelope", xmlns: "urn:publicid:-:DGTAXUD:TARIC:MESSAGE:1.0",
                        "xmlns:env" => "urn:publicid:-:DGTAXUD:GENERAL:ENVELOPE:1.0",
                        id: export_transaction_id) do |env|

  transactions.map do |transaction|
    env.tag!("env:transaction", id: transaction.id) do |transaction_node|
      transaction.messages.map do |message|
        transaction.tag!("env:app.message", id: message.id) do |message_node|
          message.tag!("oub:transmission", "xmlns:oub" => "urn:publicid:-:DGTAXUD:TARIC:MESSAGE:1.0",
                                           "xmlns:env" => "urn:publicid:-:DGTAXUD:GENERAL:ENVELOPE:1.0") do |transmission|
            transmission.tag!("oub:record") do |record|
              record.tag!("oub:transaction.id") do record
                record.text!(transaction.id)
              end

              record.tag!("oub:record.code") do record
                record.text!(message.record_code)
              end

              record.tag!("oub:subrecord.code") do record
                record.text!(message.subrecord_code)
              end

              record.tag!("oub:record.sequence.number") do record
                record.text!(message.record_sequence_number)
              end

              record.tag!("oub:update.type") do record
                record.text!(message.update_type)
              end

              Tilt.new(message.partial_path).render(message.record, xml: xml)
            end
          end
        end
      end
    end
  end
end
