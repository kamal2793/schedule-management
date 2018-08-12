# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
set :environment, 'development'

every :day, at: '12pm' do
  rake 'populate_data:populate_availability'
end
