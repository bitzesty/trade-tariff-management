module XmlGeneration
  class NodeTransaction

    attr_accessor :messages

    def initialize(records)
      @messages = Array.wrap(records).map do |record|
        ::XmlGeneration::NodeMessage.new(record)
      end
    end

    def id
      # TODO
      rand(10000000..19999999)
    end
  end
end
