class RegistrationsController < Devise::RegistrationsController
  rescue_from Stripe::CardError, with: :card_error


  def create
    build_resource(sign_up_params)

    if resource.save
      yield resource if block_given?
      if resource.active_for_authentication?
        set_flash_message :success, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      flash[:danger] = flash[:notice].to_a.concat resource.errors.full_messages
      redirect_to new_user_registration_path
    end
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :success, flash_key
      end
      sign_in resource_name, resource, bypass: true
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      flash[:danger] = flash[:notice].to_a.concat resource.errors.full_messages
      redirect_to edit_user_registration_path
    end
  end

  private
 
  def card_error(e)
    body = e.json_body
    err  = body[:error]
    flash[:danger] = err[:message]
    redirect_to new_user_registration_path
  end


end 