class RotationsController < ApplicationController
    before_filter :authenticate_user!


   


   def create
    @agenda = Agenda.find(params[:rid])
  	@rotation = @agenda.rotations.build(rotation_params)
        respond_to do |format|
          if @rotation.save
            format.html { redirect_to :back, flash[:success] = "New Set Created" }
            format.js
          else
            format.html { redirect_to :back, flash[:danger] = "Set Not Created" }
            format.js
          end
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


   def editdata
    @rotation = params[:rotid]

    render :json => { :form => render_to_string(:partial => 'editform') }

  end

   def newrotate
    @agenda = Agenda.find(params[:rotid]).id

    render :json => { :form => render_to_string(:partial => 'newform'), :agenda => @agenda }

  end



  def destroy
    @rotation = Rotation.find(params[:id])
    @agenda = @rotation.agenda
    @workout = @agenda.workout
    @rotation.destroy
    respond_to do |format|
      format.html { redirect_to workout_path(@workout) }
      format.js
    end
    
   end

   
   


	
  private

    def rotation_params
  	  params.require(:rotation).permit(:amount, :exwt, :unit, :amountdone, :weightdone)
    end


end
