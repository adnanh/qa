module ApplicationHelper
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

  def reply(success, message, objname = nil, object = nil)
    if objname.nil?
      return {success: success, message: message}
    else
      return {success: success, message: message, objname => object}
    end

  end
end
