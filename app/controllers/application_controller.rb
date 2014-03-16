class ApplicationController < ActionController::Base
  before_filter :require_logged_in, :only => [:logged_in_test]
  before_filter :require_admin, :only => [:admin_test]

  def index
  end

  def logged_in_test
    render :json => current_user
  end

  def admin_test
    render :json => current_user
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def require_logged_in
    authenticate_user!
  end

  def require_admin
    if user_signed_in?
      if current_user.user_privilege_id != 2
        flash[:alert] = "You do not have sufficient privileges to access the requested page."
        redirect_to root_path
      end
    else
      authenticate_user!
    end
  end

  def is_logged_in?
    return user_signed_in?
  end

  def is_admin?
    if user_signed_in?
      return current_user.user_privilege_id == 2;
    end
    return false
  end
end
