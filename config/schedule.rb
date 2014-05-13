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


class DailyWorker
  include Sidekiq::Worker

  def perform
  	require 'mandrill'
    appointments = Appointment.where([" ? < start_at < ?", 270.minutes.from_now, 1710,minutes.from_now ])
      appointments.each do |appointment|


      	mandrill = Mandrill::API.new 'gdATMo6lVK4YKoTdolhuBQ'
          message = {"html"=>"#{render_to_string('workouts/workout_reminder_email', :layout => false)}",
           "text"=>"Example text content",
           "subject"=>"Upcoming Workout Reminder",
           "from_email"=>"#{appointment.client.user.email}",
           "from_name"=>"",
           "to"=>
              [{"email"=>"#{appointment.client.email}",
                  "name"=>"#{appointment.client.name}",
                  "type"=>"to"}],
           "headers"=>{"Reply-To"=>"#{cappointment.client.user.email}"},
           "important"=>false,
           "track_opens"=>nil,
           "track_clicks"=>nil,
           "auto_text"=>nil,
           "auto_html"=>nil,
           "inline_css"=>nil,
           "url_strip_qs"=>nil,
           "preserve_recipients"=>nil,
           "view_content_link"=>nil,
           "bcc_address"=>"",
           "tracking_domain"=>nil,
           "signing_domain"=>nil,
           "return_path_domain"=>nil,}
           
          async = false
          ip_pool = "Main Pool"
          send_at = ""
          result = mandrill.messages.send message, async, ip_pool, send_at
              # [{"email"=>"recipient.email@example.com",
              #     "status"=>"sent",
              #     "reject_reason"=>"hard-bounce",
              #     "_id"=>"abc123abc123abc123abc123abc123"}]


  			end




      end
  end
end




every 1.day, :at => '4:30 pm' do
  runner "DailyWorker.perform_async"
end
