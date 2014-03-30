class WorkoutsController < ApplicationController
    before_action :set_workout, only: [:show, :edit, :update, :destroy]
    before_filter :authenticate_user!
    before_filter :require_permission, only: [:show, :edit, :update, :destroy]


 

  def index
    @workouts = current_user.workouts
  end

  def show
    @id = @workout.client_id
    @exercises = @workout.agendas
    @client = Client.find(@id)
    @appointment = @workout.appointment
  end

  

  def trans
    if params[:id]
      if Workout.exists?(:appointment_id => params[:id])
        @workout = Workout.find_by(appointment_id: params[:id])
        redirect_to @workout
        return
      end
      flash[:danger] = "This appointment doesn't have a workout yet.  You can create one here."
      redirect_to :action => "new", :id => params[:id]
      return
      
    end
      redirect_to appointments_path
  end

  def new
    @workout = Workout.new
    if params[:id]
      
      if Workout.exists?(:appointment_id => params[:id])
        @workout = Workout.find_by(appointment_id: params[:id])
        flash[:danger] = "A workout for this appointment already exists.  Here it is for you to view and edit."
        redirect_to @workout
      end
      @workout.appointment_id = params[:id]
      @workout.client_id = Appointment.find(@workout.appointment_id).client_id
    end
    
    @times = current_user.appointments
  end

  def create
    if params[:id]
      @workout = Workout.new
      @workout.appointment_id = params[:id]
      @workout.client_id = Appointment.find(@workout.appointment_id).client_id
    end
    @workout = current_user.workouts.build(workout_params)

    respond_to do |format|
      if @workout.save
        format.html { redirect_to @workout, notice: 'workout was successfully created.' }
        format.json { render action: 'show', status: :created, location: @workout }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @workout.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @workout.update_attributes(workout_params)
        format.html { redirect_to @workout, notice: 'workout was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @workout.errors, status: :unprocessable_entity }
      end
    end
  end

private
    # Use callbacks to share common setup or constraints between actions.
    def set_workout
      @workout = Workout.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def workout_params
      params.require(:workout).permit(:name, :client_id, :appointment_id)
    end

    def require_permission
      if current_user.id != @workout.user_id
        redirect_to root_path
        #Or do something else here
      end
    end


  
end
