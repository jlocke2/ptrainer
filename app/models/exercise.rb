class Exercise < ActiveRecord::Base
		belongs_to :trainer
		has_many :agendas
		has_many :workouts, :through => :agendas

		validates :name, presence: true
		validates :trainer_id, presence: true
		validates :measure, presence: true

			 scope :order_by_name, -> { order('LOWER(name)') }

end
