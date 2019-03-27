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
# => Allows us to process requests etc
# => Should upgrade after first version

# => https://gist.github.com/mdesantis/5356195
set :env_path,    '"$HOME/.rbenv/shims":"$HOME/.rbenv/bin"'

# doesn't need modifications
# job_type :command, ":task :output"

job_type :rake,   %q{ cd :path && PATH=:env_path:"$PATH" RAILS_ENV=:environment bin/rake :task --silent :output }
job_type :runner, %q{ cd :path && PATH=:env_path:"$PATH" rails runner -e :environment ':task' :output }
job_type :script, %q{ cd :path && PATH=:env_path:"$PATH" RAILS_ENV=:environment bundle exec bin/:task :output }

every 2.hours do # 1.minute 1.day 1.week 1.month 1.year is also supported
  runner "Product.download_csv" # => Should be in the Activeadmin area but had to include here to ensure it worekd
  runner "Product.sync_all"     # => Allows us to queue products in Sidekiq queue
end
