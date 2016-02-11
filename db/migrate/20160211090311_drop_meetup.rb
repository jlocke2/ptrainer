class DropMeetup < ActiveRecord::Migration
  def up
    drop_table :meetups
  end
end
