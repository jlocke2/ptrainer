class AddMeasureToExercises < ActiveRecord::Migration
  def change
    add_column :exercises, :measure, :string
  end
end
