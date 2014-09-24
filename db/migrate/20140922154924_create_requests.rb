class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.datetime :start_at
      t.datetime :end_at
      t.integer :trainer_id
      t.integer :client_id

      t.timestamps
    end
  end
end
