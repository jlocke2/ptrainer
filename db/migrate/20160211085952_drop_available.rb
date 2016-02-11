class DropAvailable < ActiveRecord::Migration
  def up
    drop_table :availables
  end
end
