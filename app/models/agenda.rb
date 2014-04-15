class Agenda < ActiveRecord::Base
	belongs_to :workout
	belongs_to :exercise
	has_many :rotations, dependent: :destroy
	accepts_nested_attributes_for :rotations, allow_destroy: true, :reject_if => :all_blank

	validates :workout_id, presence: true
	validates :exercise_id, presence: true

	


end
