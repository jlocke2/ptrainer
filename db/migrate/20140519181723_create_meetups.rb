class CreateMeetups < ActiveRecord::Migration
  def change
    create_table :meetups do |t|
      t.integer :client_id
      t.integer :appointment_id

      t.timestamps
    end
  end
end
