class Workout < ActiveRecord::Base
	belongs_to :user
    belongs_to :client
    belongs_to :appointment
	has_many :agendas
	has_many :exercises, :through => :agendas

    

end
