class AddColumnsToUsersAndTrainers < ActiveRecord::Migration
  def change
  	add_column :clients, :customer_href, :string
  	add_column :clients, :card_href, :string
  	add_column :trainers, :customer_href, :string
  	add_column :trainers, :bank_href, :string
  end
end
