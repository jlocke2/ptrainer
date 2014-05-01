class CardsController < ApplicationController
  rescue_from Stripe::CardError, with: :card_error


  def edit
      Stripe.api_key = "<%= Rails.configuration.stripe[:secret_key] %>"
      
          
          customer = Stripe::Customer.retrieve(current_user.stripe_customer_token)
          if customer.cards.any?
            customer.cards.retrieve(current_user.stripe_card_token).delete()
          end
          
          customer.cards.create(:card => params[:stripe_card_token])

          card = customer.cards.all().first  
          current_user.update_attributes(:stripe_card_token => card.id)

      flash[:success] = "Credit Card Info Updated"
      redirect_to edit_user_registration_path
    
  end

  private
 
  def card_error(e)
    body = e.json_body
    err  = body[:error]
    flash[:danger] = err[:message]
    redirect_to edit_user_registration_path
  end


end 