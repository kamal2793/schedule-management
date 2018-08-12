class AvailabilitiesController < ApplicationController
  before_action :authenticate_request, only: %i[index]

  def index
    availabilities = Availability.where(date: params[:date]).group(:doctor_id)
                       .pluck('doctor_id, array_agg(distinct case when is_available = true THEN slot_id END), array_agg(distinct case when is_available = false THEN slot_id END)')
                       .map { |i| { doctor_id: i[0], slots: i[1] - i[2] } }

    appointments = Appointment.where(appointment_date: params[:date]).where.not(status: 'cancelled').group(:doctor_id)
                      .pluck('doctor_id, array_agg(slot_id)').to_h

    final_result = []
    availabilities.each do |i|
      doctor_id = i[:doctor_id]
      available_slots = i[:slots]
      booked_slots = appointments[doctor_id]
      slots_available = available_slots - booked_slots
      final_result << { doctor_id: doctor_id, slots_available: slots_available }
    end

    render json: final_result
  end

  private

  def valid_index?
    param! :date, DateTime, required: true, blank: false
  end
end
