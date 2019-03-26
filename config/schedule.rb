# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# => Run process every hour
every 1.hour do # 1.minute 1.day 1.week 1.month 1.year is also supported
  runner "Process.download_csv" # => Should be in the Activeadmin area but had to include here to ensure it worekd
  rake "my:rake:task"
  command "/usr/bin/my_great_command"
end
