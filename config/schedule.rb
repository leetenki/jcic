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
set :output, '/home/leetenki/jcic/log/crontab.log'

#crontab for production
set :environment, :production

every 1.day, :at => '3:20 am' do
  runner "Session.sweep"
end

every 1.day, :at => '3:30 am' do
  runner "Project.sweep"
end

every 1.day, :at => '2:59 pm' do
  command "cd /home/leetenki/jcic/log && sh unicorn_log_dumper.sh"
end