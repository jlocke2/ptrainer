class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :authenticate_user!
  layout :layout_by_resource
  include Pundit
  after_action :verify_authorized

  

   def layout_by_resource
    if devise_controller? && resource_name == :user && action_name == 'new'
      "blank"
    elsif devise_controller? && resource_name == :user && action_name == 'show'
      "blank"
    elsif devise_controller? && resource_name == :user && action_name == 'update'
      "blank"
    else
      "application"
    end
  end

  protected


 
  def configure_permitted_parameters
    #This allows the attributes to be accessible at sign up. I had to add email and password after adding token. 
    devise_parameter_sanitizer.for(:sign_up) << :plan
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :plan) }
    devise_parameter_sanitizer.for(:account_update) { |u| 
      u.permit(:email, :password, :password_confirmation, :current_password) 
    }
  end

  
end
