class CreateRotations < ActiveRecord::Migration
  def change
    create_table :rotations do |t|

      t.timestamps
    end
  end
end
