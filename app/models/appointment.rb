class Appointment < ApplicationRecord
  enum staus: {
    booked: 'booked',
    payment_done: 'payment_done',
    cancelled: 'cancelled'
  }.freeze

  belongs_to :doctor
  belongs_to :patient
  belongs_to :slot

  validates_presence_of :appointment_date, :status
  validates_uniqueness_of :appointment_date, scope: [:doctor_id, :slot_id] #TODO need to modify.
  validate :valid_appointment_date
  validate :slot_availability

  def valid_appointment_date
    errors.add(:appointment_date, 'should be a current or future date.') if self.appointment_date.to_date < Date.today
    errors.add(:appointment_date, 'should be be in next 15 days.') if self.appointment_date.to_date > (Date.today + 15.days)
  end

  def slot_availability
    available_slot = self.doctor.availabilities.where(date: self.appointment_date, slot_id: self.slot_id).pluck(:is_available).uniq
    if (not available_slot.present? || available_slot.include?(false))
      self.errors.add(:base, 'Slot not available.')
    end

    booked_appointment = Appointment.where(date: self.appointment_date, slot_id: self.slot_id, doctor_id: self.doctor_id).where.not(status: 'cancelled')
    if booked_appointment.exist
      self.errors.add(:base, 'Appointment has already been taken.')
    end
  end
end
