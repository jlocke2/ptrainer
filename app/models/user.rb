class User < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable


  has_many :relationships, foreign_key: "client_id", dependent: :destroy
  has_many :clients, through: :reverse_relationships, source: :follower


  has_many :trainers, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "trainer_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy

  has_many :user_appointments, dependent: :destroy                            
  has_many :appointments, through: :user_appointments

  has_many :exercises, dependent: :destroy

  after_create :add_default_exercises

  validates :type, presence: true

  ##########################################
  ##
  ## Methods for checking the User's Type
  ##
  ###########################################
  def admin?
    user.type == "Admin"
  end

  def trainer?
    user.type == "Trainer"
  end

  def client?
    user.type == "Client"
  end
 

  # new function to set the password without knowing the current password used in our confirmation controller. 
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end
  # new function to return whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end

  # new function to provide access to protected method unless_confirmed

  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end

  def password_required?
    # Password is required if it is being set, but not for new records
    if !persisted? 
      false
    else
      !password.nil? || !password_confirmation.nil?
    end
  end

  def password_match?
    self.password == self.password_confirmation
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

