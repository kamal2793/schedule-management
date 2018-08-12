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
  validate :slot_timing

  def valid_appointment_date
    errors.add(:appointment_date, 'should be a current or future date.') if self.appointment_date < Date.today
    errors.add(:appointment_date, 'should be be in next 7 days.') if self.appointment_date > (Date.today + 6.days)
  end

  def slot_timing
    self.errors.add(:base, 'Slot time is passed.') if self.slot.start_time.strftime('%H:%M') < Time.now.strftime('%H:%M')
  end
end
