class RegistrationsController < Devise::RegistrationsController

   def setting 
     # @user = User new
     # render action: :settings
        @user = current_user
        if @user 
            render :settings
        else
            render file: 'public/404', status: 404, formats: [:html]
         end 
   end
  
   def update
     @user = User.find(current_user.id)

     successfully_updated = if needs_password?(@user, params)
       #@user.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
      @user.update_with_password(params[:user])
     else
       # remove the virtual current_password attribute
       # update_without_password doesn't know how to ignore it
       params[:user].delete(:current_password)
      # @user.update_without_password(devise_parameter_sanitizer.sanitize(:account_update))
       @user.update_without_password(params[:user])

     end

     if successfully_updated
       set_flash_message :notice, :updated
       # Sign in the user bypassing validation in case their password changed
       sign_in @user, :bypass => true
       redirect_to @user
     else
      Rails.logger.info("Test5")
       render "edit"
     end
   end
   
   private

  # check if we need password to update user data
  # ie if password or email was changed
  # extend this as needed
  def needs_password?(user, params)
    user.email != params[:user][:email] ||
      params[:user][:password].present? ||
      params[:user][:password_confirmation].present?
  end

  #  def update
  #     # For Rails 4
  #     #account_update_params = devise_parameter_sanitizer.sanitize(:account_update)
  #     # For Rails 3
  #     account_update_params = params[:user]

  #     # required for settings form to submit when password is left blank
  #     if account_update_params[:password].blank?
  #       account_update_params.delete("password")
  #       account_update_params.delete("password_confirmation")
  #     end

  #     @user = User.find(current_user.id)
  #     if @user.update_attributes(account_update_params)
  #       set_flash_message :notice, :updated
  #       # Sign in the user bypassing validation in case their password changed
  #       sign_in @user, :bypass => true
  #       redirect_to after_update_path_for(@user)
  #     else
  #       render "edit"
  #     end
  # end
  
end