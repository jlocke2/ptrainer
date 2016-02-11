class DropTrainer < ActiveRecord::Migration
  def up
    drop_table :trainers
  end
end
