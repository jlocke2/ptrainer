class Appointment < ActiveRecord::Base


  include ActionView::Helpers::DateHelper

		belongs_to :user


    has_many :meetups, dependent: :destroy
    has_many :clients, through: :meetups

    has_one :workout, dependent: :destroy

        validates :start_at, presence: true
        validates :end_at, presence: true
        validates :user_id, presence: true

   


   def self.perform

    require 'mandrill'
    appointments = Appointment.where([" ? < start_at AND start_at < ?", Time.current.advance(minutes: 270), Time.current.advance(minutes: 1710) ])
      appointments.each do |appointment|

         @meetups = appointment.meetups
         @attends = []
          @meetups.each do |meetup|
            @name = Client.find(meetup.client_id).id
            @attends << @name
          end

      @attends.each do |attend|

        if Client.find(attend).email =~ /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

        mandrill = Mandrill::API.new 'gdATMo6lVK4YKoTdolhuBQ'
          message = {"html"=>" <p>Hey #{Client.find(attend).name}!  Hope you are having a great day!</p>
  <p>Just wanted to remind you of our upcoming appointment on #{appointment.start_at.strftime("%A %D")} at #{appointment.start_at.strftime("%I:%M%P")}</p>
  <p>Look forward to seeing you then!</p>
  <p>Thanks</p>
  <p>#{Client.find(attend).user.email}</p>",
           "text"=>"",
           "subject"=>"Upcoming Workout Reminder",
           "from_email"=>"#{Client.find(attend).user.email}",
           "from_name"=>"",
           "to"=>
              [{"email"=>"#{Client.find(attend).email}",
                  "name"=>"#{Client.find(attend).email}",
                  "type"=>"to"}],
           "headers"=>{"Reply-To"=>"#{Client.find(attend).user.email}"},
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
