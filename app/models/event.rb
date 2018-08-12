class Event < ApplicationRecord
  enum recurrence_type: {
    daily: 'daily',
    weekly: 'weekly'
  }.freeze

  belongs_to :doctor
  has_many :availabilities

  validates_presence_of :start_date, :start_time, :end_time, :recurrence_type
  validate :valid_start_date

  after_create :populate_availability

  def populate_availability
    slots = Slot.where("start_time >= ? and end_time <= ?", self.start_time.strftime("%H:%M:%S"), self.end_time.strftime("%H:%M:%S"))
    is_available = self.is_available

    if recurrence_type == 'daily'
      availability = []
      interval = (1 + recurrence_step.to_i).days
      start_date = self.start_date
      end_date = if self.end_date.present?
                   [self.end_date, self.start_date + 7.days].min
                 else
                   start_date + 7.days
                 end

      while start_date < end_date
        slots.each do |slot|
          availability << self.availabilities.new(date: start_date, slot: slot, is_available: is_available)
        end
        start_date += interval
      end

      Availability.import!(availability, validate: true, on_duplicate_key_ignore: true)
    end
  end

  def valid_start_date
    return if end_date.nil?
    if end_date < start_date
      self.errors.add(:start_date, 'Should be less than end date')
    end
  end
end
