class Trainer < ActiveRecord::Base
	has_one :user, :as => :rolable

	  has_many :clients, dependent: :destroy
	  has_many :appointments, dependent: :destroy
	  has_many :exercises, dependent: :destroy
	  has_many :workouts, dependent: :destroy

end
