class CreateAgendas < ActiveRecord::Migration
  def change
    create_table :agendas do |t|
      t.integer :workout_id
      t.integer :exercise_id

      t.timestamps
    end
  end
end
