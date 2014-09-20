class AddTrainerIdToAvailable < ActiveRecord::Migration
  def change
    add_column :availables, :trainer_id, :integer
  end
end
