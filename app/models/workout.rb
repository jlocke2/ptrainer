class Workout < ActiveRecord::Base
  
	belongs_to :appointment
  belongs_to :exercise

	validates :trainer_id, presence: true
	validates :appointment_id, presence: true  

end
