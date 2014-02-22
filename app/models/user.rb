class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :clients, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :exercises, dependent: :destroy
  has_many :workouts, dependent: :destroy

end
