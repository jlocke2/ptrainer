class AddColumnsToAgendas < ActiveRecord::Migration
  def change
    add_column :agendas, :set, :integer
    add_column :agendas, :rep, :integer
  end
end
