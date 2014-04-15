class Rotation < ActiveRecord::Base
	belongs_to :agenda

	validates :agenda_id, presence: true
end
