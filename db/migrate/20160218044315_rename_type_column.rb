class RenameTypeColumn < ActiveRecord::Migration
  def change
    rename_column :users, :type, :role
  end
end
