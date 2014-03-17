class AddOrderToClients < ActiveRecord::Migration
  def change
    add_column :clients, :row_order, :integer
  end
end
