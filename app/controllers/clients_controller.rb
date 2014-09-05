class ClientsController < ApplicationController
    before_action :set_client, only: [:show, :edit, :update, :destroy, :appointments, :workouts, :progress]
    before_filter :authenticate_user!
    before_filter :require_permission, only: [:show, :edit, :update, :destroy, :appointments, :progress]



   def index
    @search = current_user.clients.order_by_name.search(params[:q])
   	@clients = @search.result.order(name: :asc)
    @client = Client.new
    
   	
   end

   def import
     Client.import(params[:file], current_user.id)
     redirect_to clients_path, notice: "Clients imported."
   end

   def sort
    @client = Client.find(params[:id])

    # .attributes is a useful shorthand for mass-assigning
    # values via a hash
    @client.update_attribute :row_order_position, params[:thing][:row_order_position]
    @client.save

    # this action will be called via ajax
    render nothing: true
  end

   


   def new
   	@client  = Client.new
   	
   end

   def show
    @client = Client.find(params[:id])
    @appointments = @client.appointments.where(["start_at < ?", Time.now]).order(start_at: :desc).limit(4)
    @notes = @client.notes.order(created_at: :desc).limit(5)
     
   end


   def create
  	@client = current_user.clients.build(client_params)
    @search = current_user.clients.search(params[:q])
    @clients = @search.result.rank(:row_order)
      respond_to do |format|
        if current_user.plan = "solo"
          if current_user.clients.count > 50
            format.js { render :partial => 'fail_create.js.erb' }
          else
            if @client.save
              format.html { redirect_to clients_path, flash[:success] = "Client created!" }
              format.js
            else
              format.html { redirect_to root_url }
              format.js { "window.location.href = ('#{root_path}');" }
            end
          end
        else
          if current_user.clients.count > 50
            format.js { render :partial => 'fail_create_plus.js.erb' }
          else
            if @client.save
              format.html { redirect_to clients_path, flash[:success] = "Client created!" }
              format.js
            else
              format.html { redirect_to root_url }
              format.js { "window.location.href = ('#{root_path}');" }
            end
          end
        end
      end
    end

   

   def edit
     @client = Client.find(params[:id])   	
   end

   def update
   	 @client = Client.find(params[:id]) 
        respond_to do |format|
        if @client.update_attributes(client_params)
          format.html { redirect_to clients_path, flash[:success] = "Profile updated" }
          format.js
        else
          format.html { render action: 'edit' }
          format.js {}
        end
      end


    end
   	
   


   def destroy
   	Client.find(params[:id]).destroy
    flash[:success] = "Client destroyed."
    redirect_to clients_path
   	
   end

   def appointments
      @client = Client.find(params[:id])
      @appointments = @client.appointments.order(start_at: :desc)
   end

   def notes
     @notes = Note.where(client_id: params[:id]).order(created_at: :desc)
      @client = Client.find(params[:id])
   end

   def workouts
      @workouts = Workout.where(client_id: params[:id])
      redirect_to client_path(@client)
   end

   def progress

      @client = Client.find(params[:id])
      apts = @client.appointments
      @workouts = []
      apts.each do |apt|
       @workouts << apt.workout.id
      end
      @press = []
      info1 = []
      info2 = []
      info3 = []
      @agendas = Agenda.where(workout_id: @workouts)
      h={}
      
     if request.patch?
        @id = params[:user][:id]
        @id = @id.to_i
        @agendas = @agendas.where(exercise_id: @id)
        @agendas.each do | type|
        @press << type if type.exercise_id == @id



          end
      end
      @agendas.each_with_index do |agenda, index|
                info1 << {
                :when => Workout.find(agenda.workout_id).appointment.start_at.strftime("%D"), 
                :repdone1 => agenda.rotations[0].amountdone.to_i}
                if agenda.rotations.count >= 2
        info2 << {
          :when => Workout.find(agenda.workout_id).appointment.start_at.strftime("%D"), 
                :repdone1 => agenda.rotations[1].amountdone.to_i}
              end
              if agenda.rotations.count >= 3
        info3 << {
          :when => Workout.find(agenda.workout_id).appointment.start_at.strftime("%D"), 
                :repdone1 => agenda.rotations[2].amountdone.to_i}
              end
        h = { :set1 => info1, :set2 => info2, :set3 => info3}

      end


        respond_to do |format|
          format.html
          format.js
          format.json {render :json => h.to_json}
        
      end
   end

   def progcharter

    if request.patch?

    @client = Client.find(params[:id])
      @workouts = Workout.where(client_id: @client)
      @press = []
      info1 = []
      info2 = []
      info3 = []
      h = {}
      @id = params[:but]
        @id = @id.to_i
      
      @agendas = Agenda.where(workout_id: @workouts)
      @agenadas = @agendas.where(exercise_id: @id )

      @agendas.each_with_index do |agenda, index|
                info1 << {
                :when => Workout.find(agenda.workout_id).appointment.start_at.strftime("%D"), 
                :repdone1 => agenda.rotations[0].amountdone.to_i}
                if agenda.rotations.count >= 2
        info2 << {
          :when => Workout.find(agenda.workout_id).appointment.start_at.strftime("%D"), 
                :repdone1 => agenda.rotations[1].amountdone.to_i}
              end
              if agenda.rotations.count >= 3
        info3 << {
          :when => Workout.find(agenda.workout_id).appointment.start_at.strftime("%D"), 
                :repdone1 => agenda.rotations[2].amountdone.to_i}
              end
        h = { :set1 => info1, :set2 => info2, :set3 => info3}

      end

      respond_to do |format|
          format.json {render :json => h.to_json}
        
      end
    end

     end
   


	
  private

    def set_client
      @client = Client.find(params[:id])
    end

    def client_params
  	  params.require(:client).permit(:name, :age, :gender, :email, :phone, :notes, :row_order)
    end

    def require_permission
      if current_user.id != @client.user_id
        redirect_to root_path
        #Or do something else here
      end
    end

end
