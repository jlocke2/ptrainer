class CreateUserAppointments < ActiveRecord::Migration
  def change
    create_table :user_appointments do |t|
      t.integer :user_id
      t.integer :appointment_id

      t.timestamps null: false
    end
      add_index :user_appointments, :user_id
      add_index :user_appointments, :appointment_id
      add_index :user_appointments, [:user_id, :appointment_id], unique: true
  end
end
