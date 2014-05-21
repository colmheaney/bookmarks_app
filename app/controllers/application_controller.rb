class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  rescue_from CanCan::AccessDenied do |excaption|
    if current_user.nil?
      session[:next] = request.fullpath
      redirect_to root_url, :alert => "Please log in to continue"
    else
      if request.env["HTTP_REFERER"].present?
        redirect_to :back, :alert => exception.message
      else
        render :file => "#{Rails.root}/public/403.html", :status => 403, :layout => false
      end
    end
  end
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) {|u| u.permit(:signin)}
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:email,
                                                           :username, :password, :password_confirmation)}
  end
end
