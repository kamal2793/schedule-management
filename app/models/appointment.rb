class Appointment < ApplicationRecord
  enum staus: {
    booked: 'booked',
    cancelled: 'cancelled'
  }.freeze

  belongs_to :doctor
  belongs_to :patient
end
