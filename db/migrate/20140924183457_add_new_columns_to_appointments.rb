class AddNewColumnsToAppointments < ActiveRecord::Migration
  def change
  	add_column :appointments, :allowjoin, :string
  	add_column :appointments, :maxjoin, :string
  end
end
