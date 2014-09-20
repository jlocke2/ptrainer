class CreateAvailables < ActiveRecord::Migration
  def change
    create_table :availables do |t|
      t.string :name
      t.text :description
      t.datetime :start_at
      t.datetime :end_at
      t.string :day_of_week

      t.timestamps
    end
  end
end
