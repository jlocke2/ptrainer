class Meetup < ActiveRecord::Base
	belongs_to :client
	belongs_to :appointment
end
