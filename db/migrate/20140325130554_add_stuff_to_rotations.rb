class AddStuffToRotations < ActiveRecord::Migration
  def change
  	add_column :rotations, :amount, :string
  	add_column :rotations, :agenda_id, :integer
  end
end
