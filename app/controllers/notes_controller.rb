class NotesController < ApplicationController
      before_filter :authenticate_user!

	def create
  	@client = Client.find(params[:client])
    @note = @client.notes.build(note_params)
    @notes = @client.notes
    
      respond_to do |format|
        if @note.save
          format.html { redirect_to clients_path(@client), flash[:success] = "Note created!" }
          format.js
        else
          format.html { redirect_to root_path }
        end
      end
    end


 private

    def note_params
  	  params.require(:note).permit(:description, :client_id)
    end





end
