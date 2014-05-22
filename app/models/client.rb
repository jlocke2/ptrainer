class Client < ActiveRecord::Base
	belongs_to :user

	has_many :meetups, dependent: :destroy
	has_many :appointments, through: :meetups




	has_many :notes, dependent: :destroy

	validates :name, presence: true
	validates :user_id, presence: true

	include RankedModel
  	ranks :row_order

  	def self.import(file, current_user_id)
	  spreadsheet = open_spreadsheet(file)
	  header = spreadsheet.row(1)
	  (2..spreadsheet.last_row).each do |i|
	    row = Hash[[header, spreadsheet.row(i)].transpose]
	    client = find_by_id(row["id"]) || new
	    parameters = ActionController::Parameters.new(row.to_hash)
      	client.update(parameters.permit(:name, :age, :gender, :email, :phone))
      	client.update_attribute :user_id, current_user_id
	    client.save!
	  end
	end

	def self.open_spreadsheet(file)
	  case File.extname(file.original_filename)
	  when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
	  when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
	  when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
	  else raise "Unknown file type: #{file.original_filename}"
	  end
	end
end


