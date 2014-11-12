class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :edit, :update, :destroy, :move, :resize, :workouts, :editordata, :join, :clientremove]
  before_filter :authenticate_user!
  before_filter :require_permission, except: [:new, :create, :index, :newdata, :mastercalendar, :removefromapt, :toured]


  # GET /appointments
  # GET /appointments.json
  def index
      @appointment = Appointment.new
      @appointments = current_user.rolable.appointments
      appointments = []
      available = []
      



      if current_user.rolable_type == "Trainer"
      else
        @others = current_user.rolable.trainer.appointments.includes(:meetups).where('meetups.client_id != ?', current_user.rolable.id).references(:meetups)
        if @others.any?




     



         @others.each do |other|

               meets = Meetup.where(appointment_id: other)
        if meets.any?
          
        meets.each do |meet|
          @matches = []
          if meet.client_id == current_user.rolable.id
            @matches << "yes"
          end
        end
       else
        count = "no"
      end




      if @matches.count > 0

          appointments << {:id => other.id, :title => "Time Already Taken"  , :start => other.start_at, :end => other.end_at, :class => "unavailable"}
        end
        end
      end
    end

      if current_user.rolable_type == "Trainer"
      else
        @otherreqs = Request.where(trainer_id: current_user.rolable.trainer.id).where.not('client_id = ?', current_user.rolable.id)
        if @otherreqs.any?
         @otherreqs.each do |other|
          appointments << {:id => other.id, :title => "Time Already Requested"  , :start => other.start_at, :end => other.end_at, :class => "unavailable"}
        end
        end
      end




      if current_user.rolable_type == "Trainer"
          @unavailables = current_user.rolable.unavailables
        else
          @unavailables = current_user.rolable.trainer.unavailables
        end
        if @unavailables.any?
         @unavailables.each do |unavailable|
          appointments << {:id => unavailable.id, :title => "Unavailable Time"  , :start => unavailable.start_at, :end => unavailable.end_at, :class => "gone"}
        end
      end







        if current_user.rolable_type == "Trainer"
          @requests = Request.where(trainer_id: current_user.rolable.id)
        else
          @requests = Request.where(client_id: current_user.rolable.id)
        end
        if @requests.any?
         @requests.each do |request|
          @name = Client.find(request.client_id).name
          appointments << {:id => request.id, :title => "Appointment Request"  , :start => request.start_at, :end => request.end_at, :class => "requested", :name => @name}
        end
      end



       if current_user.rolable_type == "Trainer"
        else
          @opentimes = Appointment.includes(:meetups).where('appointments.trainer_id = ? AND meetups.client_id != ? AND appointments.allowjoin = ?',  current_user.rolable.trainer.id, current_user.rolable.id, 1.to_s).references(:meetups)
          @matches = []
          if @opentimes.any?
            @opentimes.each do |opentime|
          meets = Meetup.where(appointment_id: opentime.id)
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
        meets.each do |meet|
          
          if meet.client_id == current_user.rolable.id
            @matches << "yes"
          end
        end
       else
        count = "no"
      end

      if @matches.count > 0
      else
      if opentime.maxjoin.to_i > meets.size

          appointments << {:id => opentime.id, :title => opentime.name || "Available Group Time"  , :start => opentime.start_at, :end => opentime.end_at, :class => "opentime", :allp => allp}
          @matches.clear
        else
          appointments << {:id => opentime.id, :title => "Unavailable Time"  , :start => opentime.start_at, :end => opentime.end_at, :class => "gone"}
          @matches.clear
        end
        @matches.clear
        end
        @matches.clear
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
    @trainer = current_user.rolable

    if params[:type] == "2"


      @appointment = current_user.rolable.unavailables.build(unavailable_params)

      respond_to do |format|
      if @appointment.save
        format.html { redirect_to root_path, success: 'Unavailable time was successfully created.' }
        format.js {render :partial => 'unavailable_create.js.erb'}
      else
        format.html { render action: 'new' }
        format.js { render :partial => 'fail_create.js.erb' }
      end
    end





    else



       @appointment = current_user.rolable.appointments.build(appointment_params)
        if params[:canadd2] == "1"
          @appointment.allowjoin = "1"
          if params[:totaladd2] != ""
             @appointment.maxjoin = params[:totaladd2]
           else
            @appointment.maxjoin = "0"
          end
        else
          @appointment.allowjoin = "0"
          @appointment.maxjoin = "0"
      end

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


          meets3 = Meetup.where(appointment_id: @appointment)
          meet3ids = []
           meets3.each do |meet3|
            meet3ids << meet3.client_id
          end
          @clientidlist4 = meet3ids

        createapt_email(@appointment, @clientidlist4, @trainer)
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

   
  end

  # PATCH/PUT /appointments/1
  # PATCH/PUT /appointments/1.json
  def update
    @trainer = current_user.rolable
     clients = params[:appointment][:client_id]
        if clients.any?
         meets = Meetup.where(appointment_id: @appointment)
         meetids = []
         meets.each do |meet|
          meetids << meet.client_id.to_s
        end
        addednow = []
        removednow = []
        addednow = clients - meetids
        removednow = meetids - clients
        @clientidlist = addednow
        @clientidlist2 = removednow
        @trainer = Trainer.find(@appointment.trainer_id)
        addednow_email(@appointment, @clientidlist, @trainer)
        removednow_email(@appointment, @clientidlist2, @trainer)
      end
    if params[:canadd2] == "1"
          @appointment.allowjoin = "1"
          if params[:totaladd2] != ""
             @appointment.maxjoin = params[:totaladd2]
           else
            @appointment.maxjoin = "0"
          end
        else
          @appointment.allowjoin = "0"
          @appointment.maxjoin = "0"
      end
    @start_at = @appointment.start_at.strftime("%D %I:%M%P")

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
        if @start_at != @appointment.start_at.strftime("%D %I:%M%P")
          meets2 = Meetup.where(appointment_id: @appointment)
          meet2ids = []
           meets2.each do |meet2|
            meet2ids << meet2.client_id
          end
          @clientidlist3 = meet2ids - addednow
          changedtime_email(@appointment, @clientidlist3, @trainer)
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
    @trainer = current_user.rolable
    meets4 = Meetup.where(appointment_id: @appointment)
          meet4ids = []
           meets4.each do |meet4|
            meet4ids << meet4.client_id
          end
          @clientidlist5 = meet4ids

    removeapt_email(@appointment, @clientidlist5, @trainer)
    @appointment.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
      format.js
    end
  end


  def clientremove
    @client = current_user.rolable
    @trainer = @client.trainer
    if @appointment.meetups.count == 1
      @appointment.destroy
      clientremove_email(@client, @trainer, @appointment, "1")
      respond_to do |format|
        format.html { redirect_to :back }
        format.js {render :partial => 'removeclient.js.erb'}
      end
    else
      @appointment.meetups.find_by(client_id: @client).destroy
      clientremove_email(@client, @trainer, @appointment, "2")
      respond_to do |format|
        format.html { redirect_to :back }
        format.js {render :partial => 'removeclient.js.erb'}
      end
    end
  end

  def removefromapt
    @appointment = Appointment.find(params[:id])
    @client = Client.find(params[:clientid])
    @trainer = current_user.rolable
    if @appointment.meetups.count == 1
      removefromapt_email(@appointment, @client, @trainer)
      @appointment.destroy
      respond_to do |format|
        format.html { redirect_to :back }
        format.js {render :partial => 'removeapt.js.erb'}
      end
    else
      @appointment.meetups.find_by(client_id: @client).destroy
      removefromapt_email(@appointment, @client, @trainer)
      respond_to do |format|
        format.html { redirect_to :back }
        format.js {render :partial => 'removeapt.js.erb'}
      end
    end
  end

  def workouts
      @workouts = Workout.where(appointment_id: params[:id])
   end

  def toured
    @value = params[:value]
    current_user.rolable.update_attributes(:tour => @value)

  end


  def join
    @appointment = Appointment.find(params[:id])
    @client = current_user.rolable
    @trainer = @client.trainer
    @meetup = Meetup.new
    @meetup.appointment_id = @appointment.id
    @meetup.client_id = current_user.rolable.id
    respond_to do |format|
      if @meetup.save
        join_email(@appointment, @client, @trainer)
        format.html { redirect_to root_path, success: 'Group sessions was successfully joined.' }
        format.js {render :partial => 'join_group.js.erb'}
      else
        format.html { render action: 'new' }
        format.js { render :partial => 'fail_create.js.erb' }
      end
    end
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

    def unavailable_params
      params.require(:appointment).permit(:start_at, :end_at)
    end


    def workout_params
      params.require(:appointment).permit(:name, :appointment_id)
    end

     def require_permission
      if current_user.rolable_type == "Client" 
        if current_user.rolable.trainer.id != @appointment.trainer.id
          redirect_to root_path
          #Or do something else here
        end
      else
        if current_user.id != @appointment.trainer.user.id
          redirect_to root_path
          #Or do something else here
        end
      end
    end

    def clientremove_email(thisclient, thistrainer, thisappointment, number)
      require 'mandrill'

        if thistrainer.user.email =~ /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

        mandrill = Mandrill::API.new 'gdATMo6lVK4YKoTdolhuBQ'
          message = {"html"=>" <p>Hey #{thistrainer.name}!</p>
  <p>#{thisclient.name} has canceled their attendance to the appointment on #{thisappointment.start_at.strftime("%A %D")} at #{thisappointment.start_at.strftime("%I:%M%P")}</p>
 
  <p>There are no other clients in session, so session was also deleted.</p>
  
  <p>However, there are other clients still in this session.</p>
  
  <p>Thanks</p>
  <p>Personal Trainer Labs Team</p>",
           "text"=>"",
           "subject"=>"Client Cancellation",
           "from_email"=>"notification@personaltrainerlabs.com",
           "from_name"=>"",
           "to"=>
              [{"email"=>"#{thistrainer.user.email}",
                  "name"=>"#{thistrainer.name}",
                  "type"=>"to"}],
           "headers"=>{"Reply-To"=>""},
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

          end
        end

      def join_email(thisappointment, thisclient, thistrainer)
      require 'mandrill'

        if thistrainer.user.email =~ /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

        mandrill = Mandrill::API.new 'gdATMo6lVK4YKoTdolhuBQ'
          message = {"html"=>" <p>Hey #{thistrainer.name}!</p>
  <p>#{thisclient.name} has joined the appointment on #{thisappointment.start_at.strftime("%A %D")} at #{thisappointment.start_at.strftime("%I:%M%P")}</p>
  <p>Thanks</p>
  <p>Personal Trainer Labs Team</p>",
           "text"=>"",
           "subject"=>"Client Joined Session",
           "from_email"=>"notification@personaltrainerlabs.com",
           "from_name"=>"",
           "to"=>
              [{"email"=>"#{thistrainer.user.email}",
                  "name"=>"#{thistrainer.name}",
                  "type"=>"to"}],
           "headers"=>{"Reply-To"=>""},
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

          end
        end



      def addednow_email(thisappointment, clientlist, thistrainer)
      require 'mandrill'

      clientlist.each do |clientid|
        if clientid != ""

        client = Client.find(clientid)

        if client.user.email =~ /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

        mandrill = Mandrill::API.new 'gdATMo6lVK4YKoTdolhuBQ'
          message = {"html"=>" <p>Hey #{client.name}!</p>
  <p>#{thistrainer.name} has added you to the appointment on #{thisappointment.start_at.strftime("%A %D")} at #{thisappointment.start_at.strftime("%I:%M%P")}</p>
  <p>Please, contact #{thistrainer.name} at #{thistrainer.user.email}, if you believe this is a mistake.</p>
  <p>Thanks</p>
  <p>Personal Trainer Labs Team</p>",
           "text"=>"",
           "subject"=>"Trainer Added You To Session",
           "from_email"=>"notification@personaltrainerlabs.com",
           "from_name"=>"",
           "to"=>
              [{"email"=>"#{client.user.email}",
                  "name"=>"#{client.name}",
                  "type"=>"to"}],
           "headers"=>{"Reply-To"=>""},
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

          end
        end
      end
    end



      def removednow_email(thisappointment, clientlist, thistrainer)
      require 'mandrill'

      clientlist.each do |clientid|
        if clientid != ""

        client = Client.find(clientid)

        if client.user.email =~ /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

        mandrill = Mandrill::API.new 'gdATMo6lVK4YKoTdolhuBQ'
          message = {"html"=>" <p>Hey #{client.name}!</p>
  <p>#{thistrainer.name} has removed you from the appointment on #{thisappointment.start_at.strftime("%A %D")} at #{thisappointment.start_at.strftime("%I:%M%P")}</p>
  <p>Please, contact #{thistrainer.name} at #{thistrainer.user.email}, if you believe this is a mistake.</p>
  <p>Thanks</p>
  <p>Personal Trainer Labs Team</p>",
           "text"=>"",
           "subject"=>"Trainer Removed You From Session",
           "from_email"=>"notification@personaltrainerlabs.com",
           "from_name"=>"",
           "to"=>
              [{"email"=>"#{client.user.email}",
                  "name"=>"#{client.name}",
                  "type"=>"to"}],
           "headers"=>{"Reply-To"=>""},
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

          end
        end
      end
    end


        def changedtime_email(thisappointment, clientlist, thistrainer)
      require 'mandrill'

      clientlist.each do |clientid|
        if clientid != ""

        client = Client.find(clientid)

        if client.user.email =~ /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

        mandrill = Mandrill::API.new 'gdATMo6lVK4YKoTdolhuBQ'
          message = {"html"=>" <p>Hey #{client.name}!</p>
  <p>#{thistrainer.name} has changed the appointment time on #{thisappointment.start_at.strftime("%A %D")} to #{thisappointment.start_at.strftime("%I:%M%P")}</p>
  <p>Please, contact #{thistrainer.name} at #{thistrainer.user.email}, if you believe this is a mistake.</p>
  <p>Thanks</p>
  <p>Personal Trainer Labs Team</p>",
           "text"=>"",
           "subject"=>"Trainer Changed Time Of Session",
           "from_email"=>"notification@personaltrainerlabs.com",
           "from_name"=>"",
           "to"=>
              [{"email"=>"#{client.user.email}",
                  "name"=>"#{client.name}",
                  "type"=>"to"}],
           "headers"=>{"Reply-To"=>""},
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

          end
        end
      end
    end



        def createapt_email(thisappointment, clientlist, thistrainer)
      require 'mandrill'

      clientlist.each do |clientid|
        if clientid != ""

        client = Client.find(clientid)

        if client.user.email =~ /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

        mandrill = Mandrill::API.new 'gdATMo6lVK4YKoTdolhuBQ'
          message = {"html"=>" <p>Hey #{client.name}!</p>
  <p>#{thistrainer.name} has added you to the appointment on #{thisappointment.start_at.strftime("%A %D")} at #{thisappointment.start_at.strftime("%I:%M%P")}</p>
  <p>Please, contact #{thistrainer.name} at #{thistrainer.user.email}, if you believe this is a mistake.</p>
  <p>Thanks</p>
  <p>Personal Trainer Labs Team</p>",
           "text"=>"",
           "subject"=>"Trainer Added You To New Session",
           "from_email"=>"notification@personaltrainerlabs.com",
           "from_name"=>"",
           "to"=>
              [{"email"=>"#{client.user.email}",
                  "name"=>"#{client.name}",
                  "type"=>"to"}],
           "headers"=>{"Reply-To"=>""},
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

          end
        end
      end
    end

       def removeapt_email(thisappointment, clientlist, thistrainer)
      require 'mandrill'

      clientlist.each do |clientid|
        if clientid != ""

        client = Client.find(clientid)

        if client.user.email =~ /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

        mandrill = Mandrill::API.new 'gdATMo6lVK4YKoTdolhuBQ'
          message = {"html"=>" <p>Hey #{client.name}!</p>
  <p>#{thistrainer.name} has cancled the appointment on #{thisappointment.start_at.strftime("%A %D")} at #{thisappointment.start_at.strftime("%I:%M%P")}</p>
  <p>Please, contact #{thistrainer.name} at #{thistrainer.user.email}, if you believe this is a mistake.</p>
  <p>Thanks</p>
  <p>Personal Trainer Labs Team</p>",
           "text"=>"",
           "subject"=>"Trainer Canceled Session",
           "from_email"=>"notification@personaltrainerlabs.com",
           "from_name"=>"",
           "to"=>
              [{"email"=>"#{client.user.email}",
                  "name"=>"#{client.name}",
                  "type"=>"to"}],
           "headers"=>{"Reply-To"=>""},
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

          end
        end
      end
    end


    def removefromapt_email(thisappointment, thisclient, thistrainer)
      require 'mandrill'

        if thisclient.user.email =~ /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

        mandrill = Mandrill::API.new 'gdATMo6lVK4YKoTdolhuBQ'
          message = {"html"=>" <p>Hey #{thisclient.name}!</p>
  <p>#{thistrainer.name} has removed you from the appointment on #{thisappointment.start_at.strftime("%A %D")} at #{thisappointment.start_at.strftime("%I:%M%P")}</p>
  <p>Please, contact #{thistrainer.name} at #{thistrainer.user.email}, if you believe this is a mistake.</p>
  <p>Thanks</p>
  <p>Personal Trainer Labs Team</p>",
           "text"=>"",
           "subject"=>"Removed From Session",
           "from_email"=>"notification@personaltrainerlabs.com",
           "from_name"=>"",
           "to"=>
              [{"email"=>"#{thisclient.user.email}",
                  "name"=>"#{thisclient.name}",
                  "type"=>"to"}],
           "headers"=>{"Reply-To"=>""},
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

          end
        end


end