class AddStuffToClients < ActiveRecord::Migration
  def change
    add_column :clients, :age, :integer
    add_column :clients, :gender, :string
    add_column :clients, :email, :string
    add_column :clients, :phone, :string
    add_column :clients, :notes, :text
  end
end
