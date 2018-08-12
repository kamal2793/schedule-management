class Slot < ApplicationRecord
  has_many :availabilities

  validates_presence_of :start_time, :end_time
  validate :valid_start_time


  def valid_start_time
    if start_time > end_time
      self.errors.add(:start_time, 'should be less than end time.')
    end
  end
end
