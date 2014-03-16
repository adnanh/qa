class RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters, :only => [:create, :update]

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :current_password, :password, :password_confirmation) }
  end
end