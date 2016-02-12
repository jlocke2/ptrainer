class ModifyMoreTables < ActiveRecord::Migration
  def change
    remove_column :appointments, :trainer_id
    remove_column :appointments, :client_id
    remove_column :appointments, :allowjoin
    remove_column :appointments, :maxjoin

    remove_column :exercises, :measure

    remove_column :users, :stripe_card_token
    remove_column :users, :plan
    remove_column :users, :stripe_customer_token
    remove_column :users, :stripe_publishable_key
    remove_column :users, :access_token
    remove_column :users, :rolable_id
    remove_column :users, :rolable_type

    add_column :users, :type, :string
  end
end
