class EventsController <ApplicationController
  skip_before_action :valid_action?, only: %i[index]
  before_action :authenticate_request, only: %i[index create]

  def index
    events = doctor.events
    render json: events
  end

  def create
    event = doctor.events.create!(event_create_params)
    render json: event, status: :created
  end

  private

  def event_create_params
    params.require(:event).permit(:day_of_week,
                                  :start_time, :end_time,
                                  :start_date, :end_date,
                                  :is_available, :is_recurring,
                                  :recurrence_type, :recurrence_step)
  end

  def doctor
    @doctor ||= @current_user.doctor
    return @doctor if @doctor.present?
    raise ExceptionHandler::AuthorizationError, 'Not Authorized.'
  end

  def valid_create?
    param! :event, Hash, required: true, blank: false do |p|
      p.param! :day_of_week, Integer, blank: false
      p.param! :start_time, Time, blank: false
      p.param! :end_time, Time, blank: false
      p.param! :start_date, Date, blank: false
      p.param! :end_date, Date, blank: false
      p.param! :is_available, :boolean, blank: false, default: true
      p.param! :is_recurring, :boolean, blank: false, default: true
      p.param! :recurrence_type, String, blank: false
      p.param! :recurrence_step, Integer, blank: false, default: 0
    end
  end
end
