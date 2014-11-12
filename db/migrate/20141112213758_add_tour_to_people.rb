class AddTourToPeople < ActiveRecord::Migration
  def change
  	add_column :trainers, :tour, :string
  	add_column :clients, :tour, :string
  end
end
