class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :set_locale

  def index
  end

  def set_locale
    I18n.locale = session[:locale] || params[:locale] || I18n.default_locale
  end
end
