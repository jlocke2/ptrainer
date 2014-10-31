class CreateWeeklyinfos < ActiveRecord::Migration
  def change
    create_table :weeklyinfos do |t|
      t.integer :trainer_id
      t.integer :totalcount
      t.text :unpaid, array: true, default: []

      t.timestamps
    end
  end
end
