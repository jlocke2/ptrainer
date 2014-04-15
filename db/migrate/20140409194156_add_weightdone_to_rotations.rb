class AddWeightdoneToRotations < ActiveRecord::Migration
  def change
    add_column :rotations, :weightdone, :string
  end
end
