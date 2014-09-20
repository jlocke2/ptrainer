class ChangeSomething < ActiveRecord::Migration
	 def self.up
	    change_column :availables, :start_at, :string
	    change_column :availables, :end_at, :string
	  end
	 
	  def self.down
	    change_column :availables, :start_at, :datetime
	    change_column :availables, :end_at, :datetime
	  end
end
