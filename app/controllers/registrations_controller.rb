class RegistrationsController < Devise::RegistrationsController
#  before_filter :configure_permitted_parameters, if: :devise_controller?

  def update
    new_params = params.require(:user).permit(:email,
           :username, :current_password, :password,
           :password_confirmation)
    @user = User.find(current_user.id)
    if @user.update_with_password(new_params)
      set_flash_message :notice, :updated
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render 'edit'
    end
  end
#  protected
#
#  def configure_permitted_parameters
#    devise_parameter_sanitizer.for(:sign_up) do |u|
#      u.permit(:first_name, :last_name, :username, :email, :password, :password_confirmation)
#    end
#    devise_parameter_sanitizer.for(:account_update) do |u|
#      u.permit(:first_name, :last_name, :username, :email, :password, :password_confirmation)
#    end
#  end

end
