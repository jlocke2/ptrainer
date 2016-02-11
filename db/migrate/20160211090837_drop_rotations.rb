class DropRotations < ActiveRecord::Migration
  def up
    drop_table :rotations
  end
end
