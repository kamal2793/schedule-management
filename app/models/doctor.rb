class Doctor < ApplicationRecord
  belongs_to :user
  has_many :events
  has_many :availabilities, through: :events
  has_many :appointments
  has_many :patients, through: :appointments
end
