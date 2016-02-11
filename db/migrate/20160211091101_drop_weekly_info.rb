class DropWeeklyInfo < ActiveRecord::Migration
  def up
    drop_table :weeklyinfos
  end
end
