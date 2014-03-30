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

   

   
   


	
  private

    def rotation_params
  	  params.require(:rotation).permit(:amount)
    end

end
