class WorkoutsController < ApplicationController
    before_action :set_workout, only: [:show, :edit, :update, :destroy, :results]
    before_filter :authenticate_user!
    before_filter :require_permission, only: [:show, :edit, :update, :destroy, :results]


 

  def index
    redirect_to root_path
  end

  def show
    @appointment = @workout.appointment
    @id = @appointment.client_id
    @exercises = @workout.agendas.sort_by {|x| x.created_at}
    unless @appointment.present?
      @client = Client.find(@id)
    else
      @meetups = @appointment.meetups
      @attends = []
      @meetups.each do |meetup|
        @name = Client.find(meetup.client_id).name
        @attends << @name
        @last = @attends.last
      end
    end
  end

  def results
    @workout = Workout.find(params[:id])
    @exercises = @workout.agendas
    @id = @workout.client_id
    @appointment = @workout.appointment
    @meetups = @appointment.meetups
      @attends = []
      @meetups.each do |meetup|
        @name = Client.find(meetup.client_id).name
        @attends << @name
        @last = @attends.last
      end

  end

  def email
    @workout = Workout.find(params[:id])
    @exercises = @workout.agendas
    @appointment = @workout.appointment
    @meetups = @appointment.meetups
    @results = []
     @attends = []
      @meetups.each do |meetup|
        @name = Client.find(meetup.client_id).id
        @attends << @name
      end

      @attends.each do |attend|

    if Client.find(attend).email =~ /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
        require 'mandrill'
      
               mandrill = Mandrill::API.new 'gdATMo6lVK4YKoTdolhuBQ'
               message = {"html"=>"#{render_to_string('workouts/workout_email', :layout => false, locals: {:attend => attend})}",
                "text"=>"Example text content",
                "subject"=>"Upcoming Workout",
                "from_email"=>"#{current_user.email}",
                "from_name"=>"",
                "to"=>
                   [{"email"=>"#{Client.find(attend).email}",
                       "name"=>"#{Client.find(attend).email}",
                       "type"=>"to"}],
               "headers"=>{"Reply-To"=>"#{current_user.email}"},
                "important"=>false,
                "track_opens"=>nil,
                "track_clicks"=>nil,
                "auto_text"=>nil,
                "auto_html"=>nil,
                "inline_css"=>nil,
                "url_strip_qs"=>nil,
                "preserve_recipients"=>nil,
                "view_content_link"=>nil,
                "bcc_address"=>"",
                "tracking_domain"=>nil,
                "signing_domain"=>nil,
                "return_path_domain"=>nil,}
                
               async = false
               ip_pool = "Main Pool"
               send_at = ""
               result = mandrill.messages.send message, async, ip_pool, send_at
                   # [{"email"=>"recipient.email@example.com",
                   #     "status"=>"sent",
                   #     "reject_reason"=>"hard-bounce",
                   #     "_id"=>"abc123abc123abc123abc123abc123"}]
    
        
        
      
    
  else
    @results << "true"
   

  end
end
  if @results.any?
     respond_to do |format|
        format.js { render :partial => 'noemail.js.erb' }
      end
      flash.discard
  
  else
    respond_to do |format|
        format.js { render :partial => 'email.js.erb' }
      end
      flash.discard
end
    
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
    redirect_to root_path
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
