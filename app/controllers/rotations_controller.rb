class RotationsController < ApplicationController
    before_filter :authenticate_user!


   


   def create
    @agenda = Agenda.find(params[:id])
  	@rotation = @agenda.rotations.build(rotation_params)
    
  	  if @rotation.save
      		flash[:success] = "Client created!"
      		redirect_to clients_path
  	
      end
    end

   def update
     @rotation = Rotation.find(params[:id]) 
        respond_to do |format|
        if @rotation.update_attributes(rotation_params)
          format.html { redirect_to :back, flash[:success] = "Result Entered" }
          format.js
        else
          format.html { redirect_to :back, flash[:danger] = "Result Not Entered" }
          format.js {}
        end
      end


    end

   
   


	
  private

    def rotation_params
  	  params.require(:rotation).permit(:amount, :exwt, :unit, :amountdone, :weightdone)
    end


end
