class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :edit, :update, :destroy, :move, :resize, :workouts]
  before_filter :authenticate_user!
  before_filter :require_permission, except: [:new, :create, :index]


  # GET /appointments
  # GET /appointments.json
  def index
    @appointments = current_user.appointments
  end

  # GET /appointments/1
  # GET /appointments/1.json
  def show
  	@clientid = @appointment.client_id
  	@client = Client.find(@clientid)
  end

  # GET /appointments/new
  def new
    @appointment = Appointment.new
  end

  # GET /appointments/1/edit
  def edit
  end

  # POST /appointments
  # POST /appointments.json
  def create
    @appointment = current_user.appointments.build(appointment_params)

    respond_to do |format|
      if @appointment.save
        format.html { redirect_to @appointment, notice: 'appointment was successfully created.' }
        format.json { render action: 'show', status: :created, location: @appointment }
      else
        format.html { render action: 'new' }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /appointments/1
  # PATCH/PUT /appointments/1.json
  def update
    respond_to do |format|
      if @appointment.update_attributes(appointment_params)
        format.html { redirect_to @appointment, notice: 'appointment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  def move
         if @appointment
        @appointment.start_at = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@appointment.start_at))
        @appointment.end_at = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@appointment.end_at))
        
        @appointment.save
      end
      render :nothing => true
      
    end


      def resize
         if @appointment
        @appointment.end_at = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@appointment.end_at))
        
        @appointment.save
      end
      render :nothing => true
      
    end

  # DELETE /appointments/1
  # DELETE /appointments/1.json
  def destroy
    @appointment.destroy
    respond_to do |format|
      format.html { redirect_to appointments_url }
      format.json { head :no_content }
    end
  end

  def workouts
      @workouts = Workout.where(appointment_id: params[:id])
   end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def appointment_params
      params.require(:appointment).permit(:name, :client_id, :description, :start_at, :end_at)
    end

    def require_permission
	  if current_user.id != @appointment.user_id
	    redirect_to root_path
	    #Or do something else here
	  end
end


end