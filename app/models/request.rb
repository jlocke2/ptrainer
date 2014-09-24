class Request < ActiveRecord::Base
	belongs_to :trainer
	belongs_to :client

	validates :start_at, :end_at, :overlap => {:scope => "trainer_id", :exclude_edges => ["start_at", "end_at"]}

	validate :check_times3

	private

      def check_times3
        if self[:end_at] < self[:start_at]
          errors[:end_date] << "Error message"
          return false
        end

      end


end
