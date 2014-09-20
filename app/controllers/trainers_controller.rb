class TrainersController < ApplicationController
	before_action :set_trainer, only: [:show]
    before_filter :authenticate_user!
    before_filter :require_permission, only: [:show]


    def setschedule
    	
    	@trainer = Trainer.find(params[:id])
		    respond_to do |format|
			     if @trainer.update_attributes(trainer_params)
			      format.html  { redirect_to root_path }
			      format.js { render :partial => 'update_master.js.erb'}
			  	else
			  		format.html  { redirect_to root_path }
			      format.js { render :partial => 'update_master_fail.js.erb'}
			    end

		     end


    end


    private

	    def set_client
	      @trainer = Trainer.find(params[:id])
	    end

	    # Never trust parameters from the scary internet, only allow the white list through.
    def trainer_params
      params.require(:trainer).permit(:id, :name, availables_attributes: [:id, :_destroy, :start_at, :end_at, :day_of_week])
    end

	    

	    def require_permission
	      if current_user.id != @trainer.user.id
	        redirect_to root_path
	        #Or do something else here
	      end
	    end


end
