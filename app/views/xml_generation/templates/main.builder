xml.instruct!(:xml, version: "1.0", encoding: "utf-8")
xml.tag!("env:envelope", xmlns: "urn:publicid:-:DGTAXUD:TARIC:MESSAGE:1.0",
                        "xmlns:env" => "urn:publicid:-:DGTAXUD:GENERAL:ENVELOPE:1.0",
                        id: self.id) do |env|

  self.transactions.map do |transaction|
    env.tag!("env:transaction", id: transaction.id) do |transaction_node|
      transaction.messages.map do |message|
        transaction_node.tag!("env:app.message", id: message.id) do |message_node|
          message_node.tag!("oub:transmission", "xmlns:oub" => "urn:publicid:-:DGTAXUD:TARIC:MESSAGE:1.0",
                                           "xmlns:env" => "urn:publicid:-:DGTAXUD:GENERAL:ENVELOPE:1.0") do |transmission_node|
            transmission_node.tag!("oub:record") do |record_node|
              record_node.tag!("oub:transaction.id") do record
                record.text!(transaction.id)
              end

              record_node.tag!("oub:record.code") do record
                record.text!(message.record_code)
              end

              record_node.tag!("oub:subrecord.code") do record
                record.text!(message.subrecord_code)
              end

              record_node.tag!("oub:record.sequence.number") do record
                record.text!(message.record_sequence_number)
              end

              record_node.tag!("oub:update.type") do record
                record.text!(message.update_type)
              end

              Tilt.new(message.partial_path).render(message.record, xml: record_node)
            end
          end
        end
      end
    end
  end
end
