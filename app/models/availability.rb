class Availability < ApplicationRecord
  belongs_to :event
  belongs_to :slot

  validates_presence_of :date, :is_available
end
