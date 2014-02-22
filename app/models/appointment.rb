class Appointment < ActiveRecord::Base
		belongs_to :user
        belongs_to :client
        has_one :workout

    

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
