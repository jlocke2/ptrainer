class AddDefaultPriceToTrainer < ActiveRecord::Migration
  def change
  	add_column :trainers, :default_price, :integer
  end
end
