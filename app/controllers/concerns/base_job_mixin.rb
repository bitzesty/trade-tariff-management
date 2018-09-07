module BaseJobMixin
  extend ActiveSupport::Concern

  included do
    expose(:collection) do
      "#{klass.to_s}Decorator".constantize.decorate_collection(
        klass.reverse_order(:issue_date)
             .page(params[:page])
      )
    end
  end

  def create
    record = klass.new(
      date_filters: date_filters,
      issue_date: Time.zone.now,
      state: "P"
    )

    if record.save
      worker_klass.perform_async(record.id) unless Rails.env.test?

      redirect_to redirect_url,
                  notice: "#{record_name} was successfully scheduled. Please wait!"
    else
      redirect_to redirect_url,
                  notice: "Something wrong!"
    end
  end

  private

    def date_filters
      ops = {}

      ops[:start_date] = params[:start_date].try(:in_time_zone) || Time.current
      ops[:end_date] = params[:end_date].try(:in_time_zone) if params[:end_date].present?

      ops

    end
end
