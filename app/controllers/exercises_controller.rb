class ExercisesController < ApplicationController
	  before_action :set_exercise, only: [:show, :edit, :update, :destroy]
    before_filter :authenticate_user!



  def index
  	@exercises = current_user.exercises
    @exercise = Exercise.new
  end

  def show
  end

  def new
  	@exercise = Exercise.new
  end

  def create
  	@exercise = current_user.exercises.build(exercise_params)

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
      else
        format.html { render action: 'edit' }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
    end
  end

private
    # Use callbacks to share common setup or constraints between actions.
    def set_exercise
      @exercise = Exercise.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exercise_params
      params.require(:exercise).permit(:name, :description)
    end


  
end
