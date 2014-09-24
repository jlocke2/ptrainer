class RequestsController < ApplicationController

	def newform
		render :json => { :form => render_to_string(:partial => 'newform') }
	end

	def requestlist
		@requests = Request.where(trainer_id: current_user.rolable.id)
		render :json => { :form => render_to_string(:partial => 'requestlist') }
		
	end

	def formsforpop
		 @id = Request.find(params[:id])
		 @name = Client.find(@id.client_id).name
		 @start = @id.start_at.strftime("%a %b %e, %l:%m")
		 @end = @id.end_at.strftime("%l:%m %p")
		 if current_user.rolable_type == "Trainer"
			render :json => { :confirmform => render_to_string(:partial => 'confirmformpop'), :declineform => render_to_string(:partial => 'declineformpop'), :popinfo => render_to_string(:partial => 'popinfo'), :rid => @id }
		else
			render :json => { :declineform => render_to_string(:partial => 'declineformpopclient'), :popinfo => render_to_string(:partial => 'popinfoclient'), :rid => @id}
		end
	end

	def create
		@request = Request.new(request_params)

	    respond_to do |format|
	      if @request.save
	        format.html { redirect_to root_path, success: 'Appointment was successfully created.' }
	        format.js
	      else
	        format.html { render action: 'new' }
	        format.js { render :partial => 'fail_create.js.erb' }
	      end
	    end
		
	end

	def confirm
		@request = Request.find(params[:id])
		@appointment = Appointment.new 
		@appointment.start_at = @request.start_at
		@appointment.end_at = @request.end_at
		@appointment.trainer_id = @request.trainer_id

				respond_to do |format|
		      if @appointment.save
		        @workout = current_user.rolable.workouts.build
		        @workout.appointment_id = @appointment.id
		        @workout.save
		         
	              @meetup = Meetup.new
	              @meetup.appointment_id = @appointment.id
	              @meetup.client_id = @request.client_id
	              @meetup.save

	              @request.delete
		
		        format.html { redirect_to root_path, success: 'Appointment was successfully created.' }
		        format.js
		      else
		        format.html { render action: 'new' }
		        format.js { render :partial => 'fail_create.js.erb' }
		      end
		    end

	end


	def destroy
		@request = Request.find(params[:id])
	    @request.destroy
	    respond_to do |format|
	      format.html { redirect_to :back }
	      format.json { head :no_content }
	      format.js
	    end
	end




	private
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def request_params
      params.require(:request).permit(:trainer_id, :client_id, :start_at, :end_at)
    end



end
