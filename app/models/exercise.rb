class Exercise < ActiveRecord::Base
		belongs_to :user
		has_many :agendas
		has_many :workouts, :through => :agendas

		validates :name, presence: true
		validates :user_id, presence: true
		validates :measure, presence: true

			 scope :order_by_name, -> { order('LOWER(name)') }

end
