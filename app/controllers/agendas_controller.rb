class AgendasController < ApplicationController
    before_filter :authenticate_user!

 
  def create
    @workout = Workout.find(params[:agenda][:workout_id])
    @id = @workout.id
    @exercise = Exercise.find(params[:agenda][:exercise_id])
    @exercises = @workout.agendas
    respond_to do |format|
     if @workout.agendas.create(agenda_params)
      format.html  { redirect_to workout_path(@id) }
      format.js 
    end

     end
   end

   def update
    @agenda = Agenda.find(params[:id])
    @id = @agenda.workout_id
    @exercises = Workout.find(@id).agendas
    respond_to do |format|
     if @agenda.update_attributes(agenda_params)
      format.html  { redirect_to workout_path(@id) }
      format.js 
    end

     end
     
   end

  

  def destroy
    @agenda = Agenda.find(params[:id])
    @agenda.destroy
    @id = @agenda.workout_id
    @exercises = Workout.find(@id).agendas
    respond_to do |format|
      format.html { redirect_to workout_path(@id) }
      format.js
    end
  end

    
  
private
    # Use callbacks to share common setup or constraints between actions.
   

    # Never trust parameters from the scary internet, only allow the white list through.
    def agenda_params
      params.require(:agenda).permit(:exercise_id, :set, :rep, :weight, :setdone, :repdone, :weightdone)
    end
  




  
end