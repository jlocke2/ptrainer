class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :authenticate_user!
  layout :layout_by_resource
  include Pundit

  

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
    #This allows the attributes to be accessible at sign up. 
     devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
  end

  
end
