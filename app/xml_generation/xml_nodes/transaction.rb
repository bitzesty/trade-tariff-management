module XmlGeneration
  module XmlNodes
    class Transaction

      attr_accessor :messages

      def initialize(records)
        @messages = records.map do |record|
          ::XmlGeneration::XmlNodes::Message.new(record)
        end
      end

      def id
        # TODO
        rand(10000000..19999999)
      end
    end
  end
end
