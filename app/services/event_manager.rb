class EventManager
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
                                                 doctor: event.doctor,
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
                                               doctor: event.doctor,
                                               is_available: is_available)
    end

    Availability.import!(availability, validate: true, on_duplicate_key_ignore: true)
  end

  def handle_update(params)
    event.update_attributes!(params)
    # archive all future availabilities (day + 15 days)
    available_slots_before_update = archived_availabilities
    available_slots_after_update = date_wise_available_slots

    available_slots_before_update.each do |date, slots|
      rejectabe_slots = slots - available_slots_after_update[date]
      # We know the doctor of this event so cancel all appointments of that doctor (date, rejectabe_slots)
    end
    event.populate_availability
    event
  end

  def archived_availabilities
    {}
    # Archive Availability and return data wise, available slots
    # event.availabilities.where(is_available: true, archived: true, date: Date.today..(Date.today+15.days)).
    #   group(:date).pluck('date, array_agg(distinct slot_id)').map { |i| [i[0].to_s, i[1]] }.to_h
  end

  def date_wise_available_slots
    event.availabilities.where(is_available: true, date: Date.today..(Date.today+15.days)).
      group(:date).pluck('date, array_agg(distinct slot_id)').map { |i| [i[0].to_s, i[1]] }.to_h
  end
end