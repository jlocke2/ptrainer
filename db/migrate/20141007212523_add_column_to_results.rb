class AddColumnToResults < ActiveRecord::Migration
  def change
  	add_column :results, :client_id, :string
  end
end
