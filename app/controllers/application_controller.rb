class ApplicationController < ActionController::Base
  before_filter :require_logged_in, :only => [:logged_in_test]
  before_filter :require_admin, :only => [:admin_test]
  before_filter :set_locale

  include ApplicationHelper

  def index
    @users = User.all
  end

  def logged_in_test
    render :json => current_user
  end

  def admin_test
    render :json => current_user
  end

  def set_locale
    I18n.locale = session[:locale] || params[:locale] || I18n.default_locale
  end

  def ajax_test
    respond_to do |format|
      format.json {
        if is_logged_in?
          render :json => { response: "<span style=\"color: green;\">You are logged in as " + current_user.username + "...</span>" }
        else
          render :json => { response: "<span style=\"color: red;\">You are not logged in...</span>" }
        end
      }
      format.html { render :nothing => true }
    end
  end
end
