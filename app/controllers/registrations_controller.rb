class RegistrationsController < Devise::RegistrationsController


  def create
    build_resource(sign_up_params)

    child_class = params[:user_type]
    child_class2 = child_class.camelize.constantize
    resource.rolable = child_class2.new(params[child_class.to_s.underscore.to_sym])
    if child_class == "trainer"
      resource.rolable.name = params[:name]
      resource.skip_confirmation!
    else
      resource.rolable.name = params[:name]
      resource.rolable.age = params[:age]
      resource.rolable.gender = params[:gender]
      resource.rolable.phone = params[:phone]
      resource.rolable.trainer_id = params[:trainerid]
    end

    valid = resource.valid?
    valid = resource.rolable.valid? && valid

    if resource.save
      if child_class == "trainer"
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
        respond_to do |format|
          format.js 
        end
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
    resource.rolable.update_attributes(client_params)
    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :success, flash_key
      end
      sign_in resource_name, resource, bypass: true
      respond_to do |format|
          format.html {respond_with resource, location: after_update_path_for(resource)}
          format.js { render :partial => 'update_info.js.erb' }
        end
      
    else
      clean_up_passwords resource
      flash[:danger] = flash[:notice].to_a.concat resource.errors.full_messages
      redirect_to edit_user_registration_path
    end
  end

  def edit
    if current_user.rolable_type == "Trainer"
      @availables = current_user.rolable.availables
    end
    render :edit
  end

  private
 
  def card_error(e)
    body = e.json_body
    err  = body[:error]
    flash[:danger] = err[:message]
    redirect_to new_user_registration_path
  end

    def client_params
      params.permit(:name, :email, :age, :gender)
    end


end 