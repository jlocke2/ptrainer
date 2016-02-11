class DropResult < ActiveRecord::Migration
  def up
    drop_table :results
  end
end
