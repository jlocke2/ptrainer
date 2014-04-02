class ClientsController < ApplicationController
    before_filter :authenticate_user!


   def index
    @search = current_user.clients.search(params[:q])
   	@clients = @search.result.rank(:row_order)
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
        if @client.save
          format.html { redirect_to clients_path, flash[:success] = "Client created!" }
          format.js
        else
          format.html { render action: 'new' }
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
        end
      end


    end
   	
   


   def destroy
   	Client.find(params[:id]).destroy
    flash[:success] = "Client destroyed."
    redirect_to clients_path
   	
   end

   def appointments
      @appointments = Appointment.where(client_id: params[:id]).order(start_at: :desc)
      @client = Client.find(params[:id])
   end

   def notes
     @notes = Note.where(client_id: params[:id]).order(created_at: :desc)
      @client = Client.find(params[:id])
   end

   def workouts
      @workouts = Workout.where(client_id: params[:id])
   end

   def progress

      @client = Client.find(params[:id])
      @workouts = Workout.where(client_id: @client)
      @press = []
      info = []
      @agendas = Agenda.where(workout_id: @workouts)
      
     if request.patch?
        @id = params[:user][:id]
        @id = @id.to_i
        @agendas = @agendas.where(exercise_id: @id)
        @agendas.each do | type|
        @press << type if type.exercise_id == @id



          end
      end
      @agendas.each do |agenda|
        info << {:workout_id => agenda.workout_id,
                :when => Workout.find(agenda.workout_id).appointment.start_at.strftime("%D"), 
                :exercise => Exercise.find(agenda.exercise_id).name, :exercise_id => agenda.exercise_id,
                :repdone => agenda.repdone.to_i, :setdone => agenda.setdone} 
      end


        respond_to do |format|
          format.html
          format.js
          format.json {render :json => info.to_json}
        
      end
   end

   def progcharter

    if request.patch?

    @client = Client.find(params[:id])
      @workouts = Workout.where(client_id: @client)
      @press = []
      info = []
      @id = params[:but]
        @id = @id.to_i
      
      @agendas = Agenda.where(workout_id: @workouts)
      @agenadas = @agendas.where(exercise_id: @id )

      @agenadas.each do |agenda|
        info << {:workout_id => agenda.workout_id,
                :when => Workout.find(agenda.workout_id).appointment.start_at.strftime("%D"), 
                :exercise => Exercise.find(agenda.exercise_id).name, :exercise_id => agenda.exercise_id,
                :repdone => agenda.repdone.to_i, :setdone => agenda.setdone} 
      end

      respond_to do |format|
          format.json {render :json => info.to_json}
        
      end
    end

     end
   


	
  private

    def client_params
  	  params.require(:client).permit(:name, :age, :gender, :email, :phone, :notes, :row_order)
    end

end
