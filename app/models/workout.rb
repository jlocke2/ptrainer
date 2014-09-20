class Workout < ActiveRecord::Base
	belongs_to :trainer
    belongs_to :client
    belongs_to :appointment
	has_many :agendas, dependent: :destroy
	has_many :exercises, :through => :agendas

	validates :trainer_id, presence: true
	validates :appointment_id, presence: true

   

end
