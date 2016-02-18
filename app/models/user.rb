class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  has_many :relationships, foreign_key: "client_id", dependent: :destroy
  has_many :clients, through: :reverse_relationships, source: :trainer


  has_many :trainers, through: :relationships, source: :client
  has_many :reverse_relationships, foreign_key: "trainer_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy

  has_many :user_appointments, dependent: :destroy                            
  has_many :appointments, through: :user_appointments

  has_many :exercises, dependent: :destroy


  ##########################################
  ##
  ## Methods for checking the User's Type
  ##
  ###########################################
  def admin?
    user.role == "Admin"
  end

  def trainer?
    user.role == "Trainer"
  end

  def client?
    user.role == "Client"
  end
 

  private

    def add_default_exercises
      self.exercises.create({:name => 'Push Up', :measure => 'Reps'})
      self.exercises.create({:name => 'Squat', :measure => 'Reps'})
      self.exercises.create({:name => 'Bench Press', :measure => 'Reps'})
      self.exercises.create({:name => 'Pull Up', :measure => 'Reps'})
      self.exercises.create({:name => 'Sit Up', :measure => 'Reps'})
    end

 end

