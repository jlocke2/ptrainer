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




every '1 1 * * *' do
  set :job_template, ":job"
  command "test $(date +\%u) -ne 1 && test $(date +\%e) -ne 01 && /bin/bash /usr/local/bin/tarsnap-archive.sh daily"
end

every '1 1 * * *' do
  set :job_template, ":job"
  command "test $(date +\%u) -ne 1 && test $(date +\%e) -ne 01 && /bin/bash /usr/local/bin/tarsnap-archive.sh weekly"
end

every '1 1 1 * *' do
  set :job_template, ":job"
  command "/bin/bash /usr/local/bin/tarsnap-archive.sh monthly"
end

every 1.day, :at => '6:05 pm' do
  set :job_template, 'bash -lc ":job" '
  command "cd /home/deploy/apps/ptrainer_production/current && RAILS_ENV=production bin/rails runner 'Appointment.orders_create_and_payout'"
end

every :sunday, :at => '4:00 am' do
  set :job_template, 'bash -lc ":job" '
  command "cd /home/deploy/apps/ptrainer_production/current && RAILS_ENV=production bin/rails runner 'Appointment.weekly_review_for_trainer'"
end


every 1.day, :at => '4:30 pm' do
  set :job_template, 'bash -lc ":job" '
  command "cd /home/deploy/apps/ptrainer_production/current && RAILS_ENV=production bin/rails runner 'Appointment.perform'"
end
