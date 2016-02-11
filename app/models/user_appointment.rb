class UserAppointment < ActiveRecord::Base

  belongs_to :user
  belongs_to :appointment

  validates :user_id, presence: true
  validates :appointment_id, presence: true
  
end
