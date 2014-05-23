class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  layout :layout_by_resource

  

   def layout_by_resource
    if devise_controller? && resource_name == :user && action_name == 'new'
      "blank"
    else
      "application"
    end
  end

  protected


 
  def configure_permitted_parameters
    #This allows the attributes to be accessible at sign up. I had to add email and password after adding token. 
    devise_parameter_sanitizer.for(:sign_up) << :stripe_card_token
    devise_parameter_sanitizer.for(:sign_up) << :plan
    devise_parameter_sanitizer.for(:sign_up) << :stripe_customer_token
    devise_parameter_sanitizer.for(:sign_up) << :stripe_publishable_key
    devise_parameter_sanitizer.for(:sign_up) << :access_token
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :stripe_card_token, :plan, :stripe_customer_token) }
    devise_parameter_sanitizer.for(:account_update) { |u| 
      u.permit(:email, :password, :password_confirmation, :current_password) 
    }
  end

  
end
