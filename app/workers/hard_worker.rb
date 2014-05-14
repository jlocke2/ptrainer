class HardWorker
  include Sidekiq::Worker

  def perform
    
  	require 'mandrill'
  
          mandrill = Mandrill::API.new 'gdATMo6lVK4YKoTdolhuBQ'
          message = {"html"=>"#{render_to_string('workouts/workout_email', :layout => false)}",
           "text"=>"Example text content",
           "subject"=>"Upcoming Workout",
           "from_email"=>"#{current_user.email}",
           "from_name"=>"",
           "to"=>
              [{"email"=>"#{Workout.find(params[:id]).appointment.client.email}",
                  "name"=>"#{Workout.find(params[:id]).appointment.client.name}",
                  "type"=>"to"}],
           "headers"=>{"Reply-To"=>"#{current_user.email}"},
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
