class ChangeWorkoutColumns < ActiveRecord::Migration
  def change
    add_column :workouts, :exercise_id, :integer
    add_column :workouts, :goal, :text
    add_column :workouts, :completed, :text

    remove_column :workouts, :name
    remove_column :workouts, :trainer_id
    remove_column :workouts, :client_id
  end
end
