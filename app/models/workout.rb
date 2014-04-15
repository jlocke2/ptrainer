class Workout < ActiveRecord::Base
	belongs_to :user
    belongs_to :client
    belongs_to :appointment
	has_many :agendas, dependent: :destroy
	has_many :exercises, :through => :agendas

	validates :user_id, presence: true
	validates :client_id, presence: true
	validates :appointment_id, presence: true

   

end
