class CreateUnavailables < ActiveRecord::Migration
  def change
    create_table :unavailables do |t|
      t.datetime :start_at
      t.datetime :end_at
      t.integer :trainer_id

      t.timestamps
    end
  end
end
