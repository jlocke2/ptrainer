class AddMoreToRotations < ActiveRecord::Migration
  def change
  	add_column :rotations, :unit, :string
  	add_column :rotations, :exwt, :string
  end
end
