class PaymentsController < ApplicationController
	before_filter :authenticate_user!
	rescue_from Stripe::InvalidRequestError, with: :card_error

	def index
		
	end

	def verify
		customer = ActiveSupport::JSON.decode(`curl -X POST https://connect.stripe.com/oauth/token -d client_secret=sk_live_eIf0ipJOpy4u6Cb4ejK54Uu8 -d code=#{params[:code]} -d grant_type=authorization_code`)
		current_user.update_attributes(:stripe_publishable_key => customer["stripe_publishable_key"])
		current_user.update_attributes(:access_token => customer["access_token"])
		flash[:success] = "Successfully connected to Stripe"
        redirect_to payments_path
		
	end

	def charge
		Stripe.api_key = current_user.access_token
         	token = params[:stripe_card_token]
         	
         	charge = Stripe::Charge.create(
  				:card => token,
  				:currency => "usd",
  				:amount => params[:amount],
			)
		flash[:success] = "Charge of #{params[:amount]} cents successful!!"
		redirect_to payments_path
	end

	private
 
	  def card_error(e)
	    body = e.json_body
	    err  = body[:error]
	    flash[:danger] = err[:message]
	    redirect_to new_user_registration_path
	  end
end
