module ApplicationHelper
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def require_logged_in
    respond_to do |format|
      format.json {
        if !user_signed_in?
            render :json => reply(false, "Unauthorized"), :status => :unauthorized
            return
        end
      }

      format.html {
        authenticate_user!
      }
    end
  end

  def require_admin
    respond_to do |format|
      format.json {
        if user_signed_in?
          if current_user.user_privilege_id != 2
            render :json => reply(false, "You do not have sufficient privileges to access the requested service"), :status => :unauthorized
            return
          end
        else
          render :json => reply(false, "You do not have sufficient privileges to access the requested service"), :status => :unauthorized
          return
        end
      }

      format.html {
        if user_signed_in?
          if current_user.user_privilege_id != 2
            flash[:alert] = "You do not have sufficient privileges to access the requested page."
            redirect_to root_path
          end
        else
          authenticate_user!
        end
      }
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

  def extract_int(params, symbol)
    Integer(params[symbol]) if params.has_key?(symbol) and params[symbol].is_integer?
  end
end
