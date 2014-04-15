class Note < ActiveRecord::Base
	belongs_to :client

	validates :client_id, presence: true
	validates :description, presence: true
end
