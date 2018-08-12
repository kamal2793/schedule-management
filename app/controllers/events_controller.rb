class EventsController <ApplicationController
  before_action :set_doctor, only: [:create]

  def create
  end

  private

  def set_doctor
    @doctor = Doctor.first
  end
end
