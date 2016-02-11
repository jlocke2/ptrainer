class DropCat < ActiveRecord::Migration
  def up
    drop_table :cats
  end
end
