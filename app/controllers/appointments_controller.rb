class AppointmentsController <ApplicationController
  skip_before_action :valid_action?, only: %i[index]
  before_action :authenticate_request, only: %i[index create]

  def index
    appointments = patient.appointments
    render json: appointments
  end

  def create
    appointment = patient.appointments.create!(appointment_create_params)
    render json: appointment, status: :created
  end

  private

  def appointment_create_params
    params.require(:appointment).permit(:doctor_id, :slot_id,
                                  :appointment_date, :status)
  end

  def patient
    @patient ||= @current_user.patient
    return @patient if @patient.present?
    raise ExceptionHandler::AuthorizationError, 'Not Authorized.'
  end

  def valid_create?
    param! :appointment, Hash, required: true, blank: false do |p|
      p.param! :doctor_id, Integer, required: true, blank: false
      # p.param! :patient_id, Integer, required: true, blank: false
      p.param! :slot_id, Integer, required: true, blank: false
      p.param! :appointment_date, Date, required: true, blank: false
      p.param! :status, String, required: true, blank: false
    end
  end
end
