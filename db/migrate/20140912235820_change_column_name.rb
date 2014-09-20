class ChangeColumnName < ActiveRecord::Migration
  def change
  	rename_column :clients, :user_id, :trainer_id
  	rename_column :appointments, :user_id, :trainer_id
  	rename_column :exercises, :user_id, :trainer_id
  	rename_column :workouts, :user_id, :trainer_id
  end
end
