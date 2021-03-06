class Fans::Devise::RegistrationsController < Devise::RegistrationsController
  def update
    # For Rails 4
    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)
    # For Rails 3
    # account_update_params = params[:user]

    # required for settings form to submit when password is left blank
    if account_update_params[:password].blank?
      account_update_params.delete("password")
      account_update_params.delete("password_confirmation")
    end

    @user = Fan.find(current_fan.id)
    if @user.update_attributes(account_update_params)
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case their password changed
      sign_in @user, :bypass => true
      redirect_to fan_path(@user)
    else
      render "edit"
    end
  end

  def new
    @fan = Fan.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def after_sign_up_path_for(resource)
    fans_path
  end
end
