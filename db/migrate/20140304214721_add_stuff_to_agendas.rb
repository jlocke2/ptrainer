class AddStuffToAgendas < ActiveRecord::Migration
  def change
    add_column :agendas, :repdone, :string
    add_column :agendas, :setdone, :string
    add_column :agendas, :weightdone, :string
  end
end
