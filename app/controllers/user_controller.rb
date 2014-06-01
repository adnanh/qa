class UserController < ApplicationController

  # public user fetch
  def profile
    respond_to do |format|
      format.json{
        user_id = extract_int params, :user_id
        if user_id.nil?
          render :json => reply(false, t(:missing_params))
        else
          @user = User.where(id: user_id).first
          if @user.nil?
            render :json => reply(false, t(:no_such_user))
          else
            @questions = @user.questions.order('created_at DESC').limit(10)
            @answers = @user.answers.order('created_at DESC').limit(10)
            render :partial => 'user/user', :layout => false
          end
        end
      }
      format.html {
        render :status => :method_not_allowed, :nothing => true
        return
      }
    end
  end

end
