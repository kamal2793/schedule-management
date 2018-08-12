namespace :populate_data do
  task populate_availability: :environment do
    # Events for which we have to popolate data
    date = Date.today + 15.days
    events = Event.where("start_date <= ? and (end_date is null or end_date >= ?)", date)

    events.each do |event|
      if event.recurrence_type == 'daily'
        days_diff = (date - event.start_date.to_date).to_i
        step = event.recurrence_step.to_i + 1
        PopulateAvailability.new(event, date).create_availabilities_for_system if (days_diff % step) == 0
      elsif event.recurrence_type == 'weekly'
        start_date = event.start_date.send("#{Event::DAY_OF_WEEK[event.day_of_week.to_s]}?") ? event.start_date : event.start_date.next_week.send("#{Event::DAY_OF_WEEK[event.day_of_week.to_s]}")
        days_diff = (Date.today - start_date.to_date).to_i
        if days_diff >= 0
          step = (event.recurrence_step.to_i * 7) + 7
          PopulateAvailability.new(event).create_availabilities_for_system if (days_diff % step) == 0
        end
      end
    end
  end
end
