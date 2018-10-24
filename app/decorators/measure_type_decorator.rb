class MeasureTypeDecorator < ApplicationDecorator

  def title
    "#{object.measure_type_series_id} #{code}"
  end

  def measure_type_description
    "#{object.measure_type_series_id} #{object.description}"
  end

  def code
    object.measure_type_id
  end

  def start_date
    to_date(object.validity_start_date)
  end

  def end_date
    to_date(object.validity_end_date)
  end

  def locked?
    false # TODO
  end

  private

    def to_date(value)
      value.try(:strftime, "%d %B %Y") || '-'
    end

end
