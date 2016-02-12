class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:update, :destroy, :move, :resize, :editordata]

  # GET /appointments
  # GET /appointments.json
  def index
    @appointment = Appointment.new
    @appointments = current_user.appointments

    @appointments.each do |appointment|
      appointments << {:id => appointment.id, :title => appointment.name  , :description => appointment.description || "Some cool description here...", :start => appointment.start_at, :end => appointment.end_at, :class => ""}
    end

    respond_to do |format|
      format.html
      format.json {render :json => appointments.to_json}
    end

  end

  # PATCH/PUT /appointments/1
  # PATCH/PUT /appointments/1.json
  def update
    respond_to do |format|
      if @appointment.update_attributes(appointment_params)
        changedtime_email(@appointment, @clientidlist3, @trainer)
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

  # DELETE /appointments/1
  # DELETE /appointments/1.json
  def destroy
    @appointment.destroy
    changedtime_email(@appointment, @clientidlist3, @trainer)
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
      format.js
    end
  end

  ##########################
  ##
  ## Fullcalendar Actions
  ##
  ##########################

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

  ##########################
  ##
  ## END Fullcalendar Actions
  ##
  ##########################



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def appointment_params
      params.require(:appointment).permit(:name, :description, :start_at, :end_at)
    end

end