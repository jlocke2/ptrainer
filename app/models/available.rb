class Available < ActiveRecord::Base
	belongs_to :trainer

	before_update :check_times

	private

	    def check_times
	    	splitstart = start_at.split(/:| /)
	    	hourstart = splitstart[0]

	    	if splitstart[2] == "PM" && hourstart != "12"
	    		finalstart = hourstart.to_i + 12
	    	else
	    		finalstart = hourstart.to_i
	    	end

	    	splitend = end_at.split(/:| /)
	    	hourend = splitend[0]

	    	if splitend[2] == "PM" && hourend != "12"
	    		finalend = hourend.to_i + 12
	    	else
	    		finalend = hourend.to_i
	    	end

	    	if finalstart > finalend
	    		return false

	    	elsif finalstart == finalend
	    			minstart = splitstart[1]
				    finalminstart = minstart.to_i
				    	
				    
				    minend = splitend[1]
				    finalminend = minend.to_i

				    if finalminstart >= finalminend
				    	return false
				    end

			end

				    	
	    	

	    end




end
