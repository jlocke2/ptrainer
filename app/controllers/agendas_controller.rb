class AgendasController < ApplicationController
 
  def create
    @workout = Workout.find(params[:agenda][:workout_id])
    @id = @workout.id
    @exercise = Exercise.find(params[:agenda][:exercise_id])
     
     if @workout.agendas.create(agenda_params)
       redirect_to workout_path(@id)
     end

    
  end
private
    # Use callbacks to share common setup or constraints between actions.
   

    # Never trust parameters from the scary internet, only allow the white list through.
    def agenda_params
      params.require(:agenda).permit(:exercise_id, :set, :rep)
    end
  




  
end