class Availability < ApplicationRecord
  belongs_to :event
  belongs_to :slot
  belongs_to :doctor

  validates_presence_of :date
  validates_inclusion_of :is_available, in: [true, false]
end
