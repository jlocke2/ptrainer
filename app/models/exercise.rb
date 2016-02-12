class Exercise < ActiveRecord::Base
  
  belongs_to :trainer

  has_many :workouts, dependent: :destroy
  has_many :appointments, through: :workouts

  validates :name, presence: true
  validates :trainer_id, presence: true
  validates :measure, presence: true

  scope :order_by_name, -> { order('LOWER(name)') }

  private

    def belongs_to?(user)
      self.user == user
    end

end
