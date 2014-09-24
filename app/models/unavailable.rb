class Unavailable < ActiveRecord::Base
	belongs_to :trainer

	validates :start_at, :end_at, :overlap => {:scope => "trainer_id", :exclude_edges => ["start_at", "end_at"]}

	validate :check_times4


	private

      def check_times4
        if self[:end_at] < self[:start_at]
          errors[:end_date] << "Error message"
          return false
        end

      end



end
