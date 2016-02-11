class DropUnavailables < ActiveRecord::Migration
  def up
    drop_table :unavailables
  end
end
