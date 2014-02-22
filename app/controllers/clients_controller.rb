class ClientsController < ApplicationController

   def index
   	@clients = current_user.clients
   	
   end


   def new
   	@client  = Client.new
   	
   end


   def create
  	@client = current_user.clients.build(client_params)
    
  	  if @client.save
      		flash[:success] = "Client created!"
      		redirect_to clients_path
  	
      end
    end

   

   def edit
     @client = Client.find(params[:id])   	
   end

   def update
   	 @client = Client.find(params[:id]) 
     if @client.update_attributes(client_params)
        flash[:success] = "Profile updated"
        redirect_to clients_path
    end
   	
   end


   def destroy
   	Client.find(params[:id]).destroy
    flash[:success] = "Client destroyed."
    redirect_to clients_path
   	
   end

   def appointments
      @appointments = Appointment.where(client_id: params[:id])
   end


	
  private

    def client_params
  	  params.require(:client).permit(:name)
    end

end
