class PopulateAvailability
  attr_accessor :event, :date

  def initialize(event, date = nil)
    self.event = event
    self.date = date
  end

  def create_availabilities
    slots = Slot.where("start_time >= ? and end_time <= ?", event.start_time.strftime("%H:%M:%S"), event.end_time.strftime("%H:%M:%S"))
    is_available = event.is_available
    end_date = if event.end_date.present?
                 [event.end_date, Date.today + 15.days].min
               else
                 Date.today + 15.days
               end

    if event.recurrence_type == 'daily'
      interval = (1 + event.recurrence_step.to_i).days
      start_date = [event.start_date, Date.today].max
    elsif event.recurrence_type == 'weekly'
      interval = (7 + event.recurrence_step.to_i * 7).days
      start_date = event.start_date.send("#{Event::DAY_OF_WEEK[event.day_of_week.to_s]}?") ? event.start_date : event.start_date.next_week.send("#{Event::DAY_OF_WEEK[event.day_of_week.to_s]}")
    end

    availability = []
    while start_date <= end_date
      slots.each do |slot|
        availability << event.availabilities.new(date: start_date,
                                                 slot: slot,
                                                 is_available: is_available)
      end
      start_date += interval
    end

    Availability.import!(availability, validate: true, on_duplicate_key_ignore: true)
  end

  def create_availabilities_for_system
    slots = Slot.where("start_time >= ? and end_time <= ?", event.start_time.strftime("%H:%M:%S"), event.end_time.strftime("%H:%M:%S"))
    is_available = event.is_available
    availability = []

    slots.each do |slot|
      availability << event.availabilities.new(date: date,
                                               slot: slot,
                                               is_available: is_available)
    end

    Availability.import!(availability, validate: true, on_duplicate_key_ignore: true)
  end
end