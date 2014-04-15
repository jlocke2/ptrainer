class AddItToRotations < ActiveRecord::Migration
  def change
    add_column :rotations, :amountdone, :string
  end
end
