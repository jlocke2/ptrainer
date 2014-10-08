class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.string :repsdone
      t.string :weightdone
      t.string :unitdone
      t.integer :rotation_id

      t.timestamps
    end
  end
end
