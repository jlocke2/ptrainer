class AddClientIdToWorkouts < ActiveRecord::Migration
  def change
    add_column :workouts, :client_id, :integer
    add_column :workouts, :appointment_id, :integer
  end
end
