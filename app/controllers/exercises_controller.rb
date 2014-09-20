class ExercisesController < ApplicationController
	  before_action :set_exercise, only: [:show, :edit, :update, :destroy]
    before_filter :authenticate_user!
    before_filter :require_permission, only: [:show, :edit, :update, :destroy]




  def index
    @exercise = Exercise.new
    @search = current_user.rolable.exercises.order_by_name.search(params[:q])
    @exercises = @search.result.order_by_name
  end

  def show
  end

  def type
    @exercise = Exercise.find(params[:id])
    @measure = @exercise.measure

    respond_to do |format|
      format.json { render json: @measure.to_json }
    end
  end

  def new
  	@exercise = Exercise.new
  end

  def create
  	@exercise = current_user.rolable.exercises.build(exercise_params)
    @exercises = current_user.rolable.exercises

    respond_to do |format|
      if @exercise.save
        format.html { redirect_to @exercise, notice: 'exercise was successfully created.' }
        format.json { render action: 'show', status: :created, location: @exercise }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
  	respond_to do |format|
      if @exercise.update_attributes(exercise_params)
        format.html { redirect_to @exercise, notice: 'exercise was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    Exercise.find(params[:id]).destroy
    flash[:success] = "Exercise removed."
    redirect_to exercises_path
    
   end

private
    # Use callbacks to share common setup or constraints between actions.
    def set_exercise
      @exercise = Exercise.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exercise_params
      params.require(:exercise).permit(:name, :description, :measure)
    end

    def require_permission
      if current_user.id != @exercise.trainer.user.id
        redirect_to root_path
        #Or do something else here
      end
    end


  
end
