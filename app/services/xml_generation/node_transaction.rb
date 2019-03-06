module XmlGeneration
  class NodeTransaction
    attr_accessor :messages,
                  :id

    def initialize(id, records)
      @id = id
      # sometimes record is nil or record.class is NilClass (see oplog.rb), so we will skip it
      @messages = records.map do |record|
        ::XmlGeneration::NodeMessage.new(record) if record && record.class != NilClass
      end.compact
    end

    def node_id
      id
    end
  end
end
