class Relationship < ActiveRecord::Base

  belongs_to :trainer, class_name: "User"
  belongs_to :client, class_name: "User" 

  validates :trainer_id, presence: true
  validates :client_id, presence: true
  
end
