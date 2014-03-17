class AddWeightToAgendas < ActiveRecord::Migration
  def change
    add_column :agendas, :weight, :string
  end
end
