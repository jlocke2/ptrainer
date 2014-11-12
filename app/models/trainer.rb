class Trainer < ActiveRecord::Base
	has_one :user, :as => :rolable, dependent: :destroy

	  has_many :clients, dependent: :destroy
	  has_many :appointments, dependent: :destroy
	  has_many :exercises, dependent: :destroy
	  has_many :workouts, dependent: :destroy
	  has_many :availables, dependent: :destroy
	  has_many :unavailables, dependent: :destroy
	  has_many :requests, dependent: :destroy
	  has_many :weeklyinfos, dependent: :destroy

	  after_create :add_available
	  after_create :add_weekly_unpaid
	  after_create :add_default_exercises

	  accepts_nested_attributes_for :availables, allow_destroy: true, update_only: true

	  private
	    def add_available
	      self.availables.create({:start_at => '6:00 AM', :end_at => '8:00 PM', :day_of_week => 'Sunday'})
	      self.availables.create({:start_at => '6:00 AM', :end_at => '8:00 PM', :day_of_week => 'Monday'})
	      self.availables.create({:start_at => '6:00 AM', :end_at => '8:00 PM', :day_of_week => 'Tuesday'})
	      self.availables.create({:start_at => '6:00 AM', :end_at => '8:00 PM', :day_of_week => 'Wednesday'})
	      self.availables.create({:start_at => '6:00 AM', :end_at => '8:00 PM', :day_of_week => 'Thursday'})
	      self.availables.create({:start_at => '6:00 AM', :end_at => '8:00 PM', :day_of_week => 'Friday'})
	      self.availables.create({:start_at => '6:00 AM', :end_at => '8:00 PM', :day_of_week => 'Saturday'})
	    end

	    def add_weekly_unpaid
	    	self.weeklyinfos.create({:totalcount => 0, :unpaid => []})
	    end

	    def add_default_exercises
	      self.exercises.create({:name => 'Push Up', :measure => 'Reps'})
	      self.exercises.create({:name => 'Squat', :measure => 'Reps'})
	      self.exercises.create({:name => 'Bench Press', :measure => 'Reps'})
	      self.exercises.create({:name => 'Pull Up', :measure => 'Reps'})
	      self.exercises.create({:name => 'Sit Up', :measure => 'Reps'})
	    end

end
