class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :edit, :update, :destroy, :move, :resize, :workouts, :editordata]
  before_filter :authenticate_user!
  before_filter :require_permission, except: [:new, :create, :index, :newdata, :mastercalendar]


  # GET /appointments
  # GET /appointments.json
  def index
      @appointment = Appointment.new
      @appointments = current_user.rolable.appointments
      appointments = []
      available = []
      



      if current_user.rolable_type == "Trainer"
      else
        @others = current_user.rolable.trainer.appointments.includes(:meetups).where.not('meetups.client_id = ?', current_user.id).references(:meetups)
        if @others.any?
         @others.each do |other|
          appointments << {:id => other.id, :title => "Time Already Taken"  , :start => other.start_at, :end => other.end_at, :class => "unavailable"}
        end
        end
      end

    



      if @appointments.any?
        
      
      @appointments.each do |appointment|
        meets = Meetup.where(appointment_id: appointment)
        if meets.any?
          if meets.count > 1
           first = meets.first.client_id
           allp = []
           meets.each do |meet|
           @name = Client.find(meet.client_id).name
           allp << @name
           end
           num = meets.count
           num1 = num-1
           count = Client.find(first).name + " + " + num1.to_s + " more"
         else
          first = meets.first.client_id
          count = Client.find(first).name
          allp = Client.find(first).name
        end
       else
        count = "no"
      end

        appointments << {:id => appointment.id, :title => count  , :description => appointment.description || "Some cool description here...", :start => appointment.start_at, :end => appointment.end_at, :allp => allp, :class => ""}
      end
    end

      respond_to do |format|
      format.html
      format.json {render :json => appointments.to_json}

    end

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

  def edit
    
  end

  # GET /appointments/1/edit
  def editordata
    @apt = Appointment.find(params[:id])
        meets = Meetup.where(appointment_id: @apt)
        if meets.any?
          @allp = []
          meets.each do |meet|
          @allp << meet.client_id
        end
      end
    render :json => { :form => render_to_string(:partial => 'forms'), :apt => @apt, :id => @allp }

  end

  def newdata
    render :json => { :form => render_to_string(:partial => 'formclick') }
  end

  def mastercalendar
    availablenow = []
    if current_user.rolable_type == "Trainer"
      @availables = current_user.rolable.availables.order('created_at ASC')
    else
      @availables = current_user.rolable.trainer.availables.order('created_at ASC')
    end

    if @availables.any?
        @availables.each do |available|
          availablenow << {:id => available.id, :title => "Time Unavailable"  , :start => available.start_at, :end => available.end_at, :day => available.day_of_week}
        end
      end
      render :json => { :data => availablenow }
  end

  # POST /appointments
  # POST /appointments.json
  def create

    @appointment = current_user.rolable.appointments.build(appointment_params)

    respond_to do |format|
      if @appointment.save
        @workout = current_user.rolable.workouts.build(workout_params)
        @workout.appointment_id = @appointment.id
        @workout.save
         clients = params[:appointment][:client_id]
          clients.each do |client|
            if client != ""
              @meetup = Meetup.new
              @meetup.appointment_id = @appointment.id
              @meetup.client_id = client
              @meetup.save
            end
          end
        format.html { redirect_to root_path, success: 'Appointment was successfully created.' }
        format.json { render action: 'show', status: :created, location: @appointment }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
        format.js { render :partial => 'fail_create.js.erb' }
      end
    end
  end

  # PATCH/PUT /appointments/1
  # PATCH/PUT /appointments/1.json
  def update
    respond_to do |format|
      if @appointment.update_attributes(appointment_params)
        clients = params[:appointment][:client_id]
        if clients.any?
         meets = Meetup.where(appointment_id: @appointment)
         meets.each do |meet|
          meet.destroy
        end
      end
        
          clients.each do |client|
            if client != ""
              @meetup = Meetup.new
              @meetup.appointment_id = @appointment.id
              @meetup.client_id = client
              @meetup.save
            end
          end
        format.html { render :nothing => true }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
        format.js { render :partial => 'fail_create.js.erb' }
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
      format.html { redirect_to :back }
      format.json { head :no_content }
      format.js
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
      params.require(:appointment).permit(:name, :description, :start_at, :end_at)
    end

    def workout_params
      params.require(:appointment).permit(:name, :appointment_id)
    end

    def require_permission
  	  if current_user.id != @appointment.trainer.user.id
  	    redirect_to root_path
  	    #Or do something else here
  	  end
    end


end