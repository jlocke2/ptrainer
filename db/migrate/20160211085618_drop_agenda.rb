class DropAgenda < ActiveRecord::Migration
  def up
    drop_table :agendas
  end
end
