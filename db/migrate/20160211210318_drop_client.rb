class DropClient < ActiveRecord::Migration
  def up
    drop_table :clients
  end
end
