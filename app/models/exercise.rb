class Exercise < ActiveRecord::Base
		belongs_to :user
		has_many :agendas
		has_many :workouts, :through => :agendas
end
