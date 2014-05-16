class Appointment < ActiveRecord::Base
  include ActionView::Helpers::DateHelper
  
		belongs_to :user
    belongs_to :client
    has_one :workout, dependent: :destroy

        validates :client_id, presence: true
        validates :start_at, presence: true
        validates :end_at, presence: true
        validates :user_id, presence: true

    def config_date
      "#{start_at.strftime("%D   %I:%M%P")} - #{Client.find(client_id).name}"
    end


   def self.perform

    require 'mandrill'
    appointments = Appointment.where([" ? < start_at AND start_at < ?", 270.minutes.from_now, 1710,minutes.from_now ])
      appointments.each do |appointment|


        mandrill = Mandrill::API.new 'gdATMo6lVK4YKoTdolhuBQ'
          message = {"html"=>" <p>Hey #{appointment.client.name}!  Hope you are having a great day!</p>
  <p>Just wanted to remind you of our upcoming appointment on #{appointment.start_at.strftime("%D")}at #{appointment.start_at.strftime("%D  -   %I:%M%P")}</p>
  <p>Look forward to seeing you then!</p>
  <p>Thanks</p>
  <p>#{appointment.client.user.email}</p>",
           "text"=>"",
           "subject"=>"Upcoming Workout Reminder",
           "from_email"=>"#{appointment.client.user.email}",
           "from_name"=>"",
           "to"=>
              [{"email"=>"#{appointment.client.email}",
                  "name"=>"#{appointment.client.name}",
                  "type"=>"to"}],
           "headers"=>{"Reply-To"=>"#{appointment.client.user.email}"},
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

     
  

    

  scope :between, lambda {|start_time, end_time|
    {:conditions => ["? < start_at < ?", Appointment.format_date(start_time), Appointment.format_date(end_time)] }
  }

  # need to override the json view to return what full_calendar is expecting.
  # http://arshaw.com/fullcalendar/docs/event_data/Event_Object/
  def as_json(options = {})
    {
      :id => self.id,
      :name => self.name,
      :description => self.description || "",
      :start => start_at.rfc822,
      :end => end_at.rfc822,
      :recurring => false,
      :url => Rails.application.routes.url_helpers.appointment_path(id),
      #:color => "red"
    }

  end

  def self.format_date(date_time)
    Time.at(date_time.to_i).to_formatted_s(:db)
  end


end
