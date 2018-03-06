module XmlGeneration
  class NodeEnvelope

    include ::XmlGeneration::BaseHelper

    attr_accessor :transactions

    def initialize(records)
      @transactions = records.map do |transaction_block|
        ::XmlGeneration::NodeTransaction.new(transaction_block)
      end
    end

    def id
      # TODO
      rand(10000..19999)
    end
  end
end
