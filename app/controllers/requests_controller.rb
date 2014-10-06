class RequestsController < ApplicationController

	def newform
		render :json => { :form => render_to_string(:partial => 'newform') }
	end

	def requestlist
		@requests = Request.where(trainer_id: current_user.rolable.id)
		render :json => { :form => render_to_string(:partial => 'requestlist') }
		
	end

	def formsforpop
		 @id = Request.find(params[:id])
		 @name = Client.find(@id.client_id).name
		 @start = @id.start_at.strftime("%a %b %e, %l:%m")
		 @end = @id.end_at.strftime("%l:%m %p")
		 if current_user.rolable_type == "Trainer"
			render :json => { :confirmform => render_to_string(:partial => 'confirmformpop'), :declineform => render_to_string(:partial => 'declineformpop'), :popinfo => render_to_string(:partial => 'popinfo'), :rid => @id }
		else
			render :json => { :declineform => render_to_string(:partial => 'declineformpopclient'), :popinfo => render_to_string(:partial => 'popinfoclient'), :rid => @id}
		end
	end

	def create
		@request = Request.new(request_params)
		@trainer = current_user.rolable.trainer
		@client = current_user.rolable
	    respond_to do |format|
	      if @request.save
	      	request_email(@request, @client, @trainer)
	        format.html { redirect_to root_path, success: 'Appointment was successfully created.' }
	        format.js
	      else
	        format.html { render action: 'new' }
	        format.js { render :partial => 'fail_create.js.erb' }
	      end
	    end
		
	end

	def confirm
		@request = Request.find(params[:id])
		@trainer = Trainer.find(@request.trainer_id)
		@client = Client.find(@request.client_id)
		@appointment = Appointment.new 
		@appointment.start_at = @request.start_at
		@appointment.end_at = @request.end_at
		@appointment.trainer_id = @request.trainer_id

				respond_to do |format|
		      if @appointment.save
		      	confirm_email(@request, @client, @trainer)
		        @workout = current_user.rolable.workouts.build
		        @workout.appointment_id = @appointment.id
		        @workout.save
		         
	              @meetup = Meetup.new
	              @meetup.appointment_id = @appointment.id
	              @meetup.client_id = @request.client_id
	              @meetup.save

	              @request.delete
		
		        format.html { redirect_to root_path, success: 'Appointment was successfully created.' }
		        format.js
		      else
		        format.html { render action: 'new' }
		        format.js { render :partial => 'fail_create.js.erb' }
		      end
		    end

	end


	def destroy
		@request = Request.find(params[:id])
		@trainer = Trainer.find(@request.trainer_id)
		@client = Client.find(@request.client_id)
		deny_email(@request, @client, @trainer)
	    @request.destroy
	    respond_to do |format|
	      format.html { redirect_to :back }
	      format.json { head :no_content }
	      format.js
	    end
	end




	private
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def request_params
      params.require(:request).permit(:trainer_id, :client_id, :start_at, :end_at)
    end

        def request_email(thisrequest, thisclient, thistrainer)
      require 'mandrill'

        if thistrainer.user.email =~ /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

        mandrill = Mandrill::API.new 'gdATMo6lVK4YKoTdolhuBQ'
          message = {"html"=>" <p>Hey #{thistrainer.name}!</p>
  <p>#{thisclient.name} has requested an appointment on #{thisrequest.start_at.strftime("%A %D")} at #{thisrequest.start_at.strftime("%I:%M%P")}</p>
  <p>Please, login to your account and confirm or decline the request, so we can let them know the status of their request.</p>
  <p>Thanks</p>
  <p>Personal Trainer Labs Team</p>",
           "text"=>"",
           "subject"=>"Client Requested A New Session",
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


       def confirm_email(thisrequest, thisclient, thistrainer)
      require 'mandrill'

        if thisclient.user.email =~ /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

        mandrill = Mandrill::API.new 'gdATMo6lVK4YKoTdolhuBQ'
          message = {"html"=>" <p>Hey #{thisclient.name}!</p>
  <p>#{thistrainer.name} has confirmed your request for an appointment on #{thisrequest.start_at.strftime("%A %D")} at #{thisrequest.start_at.strftime("%I:%M%P")}</p>
  <p>Thanks!</p>
  <p>Personal Trainer Labs Team</p>",
           "text"=>"",
           "subject"=>"Trainer Confirmed Session Request",
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


       def deny_email(thisrequest, thisclient, thistrainer)
      require 'mandrill'

        if thisclient.user.email =~ /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

        mandrill = Mandrill::API.new 'gdATMo6lVK4YKoTdolhuBQ'
          message = {"html"=>" <p>Hey #{thisclient.name}!</p>
  <p>#{thistrainer.name} has denied your request for an appointment on #{thisrequest.start_at.strftime("%A %D")} at #{thisrequest.start_at.strftime("%I:%M%P")}</p>
  <p>Please, feel free to message the am #{thistrainer.user.email} to clarify why they were unable to accept this request.</p>
  <p>Thanks!</p>
  <p>Personal Trainer Labs Team</p>",
           "text"=>"",
           "subject"=>"Trainer Denied Session Request",
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
