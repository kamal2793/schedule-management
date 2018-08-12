class Event < ApplicationRecord
  enum recurrence_type: {
    daily: 'daily',
    weekly: 'weekly'
  }.freeze

  DAY_OF_WEEK =  {
    '0': 'sunday',
    '1': 'monday',
    '2': 'tuesday',
    '3': 'wednesday',
    '4': 'trursday',
    '5': 'friday',
    '6': 'saturday'
  }.stringify_keys.freeze

  belongs_to :doctor
  has_many :availabilities

  validates_presence_of :start_date,
                        :start_time,
                        :end_time,
                        :recurrence_type,
                        :recurrence_step
  validates_inclusion_of :is_available, :is_recurring, in: [true, false]

  validate :valid_start_date
  validate :valid_day_of_week

  after_create :populate_availability

  def populate_availability
    if (self.start_time.to_date < Date.today + 15.days) && (end_time.nil? || end_date.to_date > Date.today)
      EventManager.new(self).create_availabilities
    end
  end

  def valid_start_date
    return if end_date.nil?
    if end_date.to_date < start_date.to_date
      self.errors.add(:start_date, 'should be less than end date.')
    elsif start_date.to_date < Date.today
      self.errors.add(:start_date, 'should be a current or future date.')
    elsif end_date.to_date < Date.today
      self.errors.add(:end_date, 'should be a future date.')
    end
  end

  def valid_day_of_week
    self.errors.add(:day_of_week, 'should be present when recurrence type is weekly.') if self.recurrence_type == 'weekly' and self.day_of_week.nil?
  end
end
