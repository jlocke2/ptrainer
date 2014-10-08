class Rotation < ActiveRecord::Base
	belongs_to :agenda
	has_many :results, dependent: :destroy

end
