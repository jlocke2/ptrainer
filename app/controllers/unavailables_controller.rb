class UnavailablesController < ApplicationController
	def editordata
		@unavailbale = Unavailable.find(params[:id])
		@start = @unavailbale.start_at.to_formatted_s(:rfc822)
		@end = @unavailbale.end_at.to_formatted_s(:rfc822)

    render :json => { :form => render_to_string(:partial => 'forms'), :apt => @unavailbale, :start => @start, :end => @end }
	end

	  def update
	  	@unavailable = Unavailable.find(params[:id])
	    respond_to do |format|
	      if @unavailable.update_attributes(unavailable_params)
	        format.html { render :nothing => true }
	        format.json { head :no_content }
	        format.js
	      else
	        format.html { render action: 'edit' }
	        format.json { render json: @appointment.errors, status: :unprocessable_entity }
	        format.js { render :partial => 'fail_create.js.erb' }
	      end
	    end
	 end


	 def destroy
	 	@unavailable = Unavailable.find(params[:id])
	    @unavailable.destroy
	    respond_to do |format|
	      format.html { redirect_to :back }
	      format.json { head :no_content }
	      format.js
	    end
	end



  private
    # Use callbacks to share common setup or constraints between actions.

    def unavailable_params
      params.require(:unavailable).permit(:start_at, :end_at)
    end




end
