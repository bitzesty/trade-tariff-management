module XmlExport
  class FileDecorator < ApplicationDecorator

    def status
      case object.state
      when "P"
        "Pending"
      when "G"
        "Generation in progress"
      when "C"
        "Completed"
      when "F"
        "Failed"
      end
    end

    def issue_date
      to_readable_date_time(:issue_date)
    end
  end
end
