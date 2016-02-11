class DropRequest < ActiveRecord::Migration
  def up
    drop_table :requests
  end
end
