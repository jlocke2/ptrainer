class RotationsController < ApplicationController
    before_filter :authenticate_user!


   


   def create
    @agenda = Agenda.find(params[:rid])
  	@rotation = @agenda.rotations.build(rotation_params)
        respond_to do |format|
          if @rotation.save
            format.html { redirect_to :back, flash[:success] = "New Set Created" }
            format.js
          else
            format.html { redirect_to :back, flash[:danger] = "Set Not Created" }
            format.js
          end
        end
  	
      end

   def update
     
     @rotation = Rotation.find(params[:id]) 
        respond_to do |format|
        if @rotation.update_attributes(rotation_params)
          format.html { redirect_to :back, flash[:success] = "Result Entered" }
          format.js 
        else
          format.html { redirect_to :back, flash[:danger] = "Result Not Entered" }
          format.js {}
        end
      end


    end


   def editdata
    @rotation = params[:rotid]

    render :json => { :form => render_to_string(:partial => 'editform') }

  end



   def enterresults
    @rotation = params[:rotid]

    render :json => { :form => render_to_string(:partial => 'resultsform') }

  end

  def submitresults
     
   @rotation = Rotation.find(params[:id])
   @appointment = @rotation.agenda.workout.appointment
   @meetups = @appointment.meetups
   @clients = []
   @meetups.each do |meet|
    @clients << meet.client_id
   end


   if params[:client] == "0"
      @clients.each do |client|
     if @rotation.results.find_by(client_id: client.to_s).present?
      @result = @rotation.results.find_by(client_id: client.to_s)
      @result.weightdone = params[:rotation][:weightdone]
      @result.repsdone = params[:rotation][:amountdone]
      @result.save
    else #connected to if.exists?
      @result = @rotation.results.build(result_params)
      @result.client_id = client.to_s
      @result.repsdone = params[:rotation][:amountdone]
      @result.save
     end #closes if.exists?
  end #closes .each do
    respond_to do |format|
              format.js {render 'update.js.erb'}
          end #closes respond_to
   else #connected to if params[:client]
    if @rotation.results.find_by(client_id: params[:client]).present?
      @result = @rotation.results.find_by(client_id: params[:client])
      @result.weightdone = params[:rotation][:weightdone]
      @result.repsdone = params[:rotation][:amountdone]
      respond_to do |format|
             if @result.save
              format.js {render 'update.js.erb'}
             end #closes if .save
          end #closes respond_to
    else #connected to .exists?
    @result.results.build(result_params)
    @result.client_id = params[:client]
    @result.repsdone = params[:rotation][:amountdone]
    respond_to do |format|
           if @result.save
            format.js {render 'update.js.erb'}
           end #closes out if .save
        end #closes out respond_to
      end #closes out exists?
    end #closes out params[:client]


end #closes out def




   def newrotate
    @agenda = Agenda.find(params[:rotid]).id

    render :json => { :form => render_to_string(:partial => 'newform'), :agenda => @agenda }

  end



  def destroy
    @rotation = Rotation.find(params[:id])
    @agenda = @rotation.agenda
    @workout = @agenda.workout
    @rotation.destroy
    respond_to do |format|
      format.html { redirect_to workout_path(@workout) }
      format.js
    end
    
   end

   
   


	
  private

    def rotation_params
  	  params.require(:rotation).permit(:amount, :exwt, :unit, :amountdone, :weightdone)
    end

    def result_params
      params.require(:rotation).permit(:weightdone)
    end


end
