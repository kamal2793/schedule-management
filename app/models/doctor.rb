class Doctor < ApplicationRecord
  belongs_to :user
  has_many :appointments
  has_many :events
  has_many :availabilities, through: :events
end
