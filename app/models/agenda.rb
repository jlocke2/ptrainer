class Agenda < ActiveRecord::Base
	belongs_to :workout
	belongs_to :exercise

	validates :set, presence: :true
	validates :rep, presence: :true



end
