class AdminController < ApplicationController
  before_filter :require_admin

  def ban
    if (!params.has_key?(:user_id))
      # error processing bc no id has been specified
      render :json => reply(false, t(:missing_parameter))
    else
      # id has been specified
      user_to_ban = User.where(id: params[:user_id]).first
      if user_to_ban.nil?
        # attempt to ban a non-existing user?
        render :json => reply(false, t(:false_parameter))
      elsif user_to_ban.id == current_user.id
        render :json => reply(false, t(:impossible))
      else
        if user_to_ban.banned?
          # attempt to ban a user that is already banned
          render :json => reply(false, t(:already_banned_error))
        else
          # attempt to ban a user properly
          user_to_ban.banned=true
          if user_to_ban.valid?
            # changes are valid?
            user_to_ban.save
            render :json => reply(true, t(:user_banned))
          else
            render :json => reply(false, t(:unknown_error))
          end
        end
      end
    end
  end

  def unban
    if (!params.has_key?(:user_id))
      # error processing bc no id has been specified
      render :json => reply(false, t(:missing_parameter))
    else
      user_to_unban = User.where(id: params[:user_id]).first
      if user_to_unban.nil?
        # attempt to unban a non-existing user?
        render :json => reply(false, t(:false_parameter))
      else
        if !user_to_unban.banned?
          # attempt to unban a user that is not banned
          render :json => reply(false, t(:not_banned_error))
        else
          # attempt to unban a user properly
          user_to_unban.banned=false
          if user_to_unban.valid?
            # changes are valid?
            user_to_unban.save
            render :json => reply(true, t(:unbaned))
          else
            render :json => reply(false, t(:unknown_error))
          end
        end
      end
    end
  end

  def profile
    respond_to do |format|
      if params[:user_id]
        if current_user.is_admin?
          @target_user = User.where(id: params[:user_id]).first
          if @target_user.nil?
            format.json {
              render :json => reply(false, t(:false_parameter))
            }
          else
            format.json {
              render :json => reply(true, '', 'user', @target_user)
            }
          end
        else
          format.json {
            render :json => reply(false, t(:bad_privilegies))
          }
        end
      else
        format.json {
          render :json => reply(true, '', 'user', current_user)
        }
      end
    end
  end

  def edit
    respond_to do |format|
      if params[:user_id]
        # user wants to edit some other user
        if current_user.is_admin?
          # and user is an admin
          @target_user = User.where(id: params[:user_id]).first
          if @target_user.nil?
            # and target user does not exist
            format.json {
              render :json => reply(false, t(:false_parameter))
            }
          else
            #and target user exists
            @target_user.nickname = params[:new_nickname] unless params[:new_nickname].nil? || params[:new_nickname].empty?
            @target_user.email_alt = params[:new_email] unless params[:new_email].nil? || params[:new_email].empty?

            new_user_type = UserType.where(id: params[:new_user_type]).first
            @target_user.user_type = new_user_type unless new_user_type.nil?

            new_user_privilege = UserPrivilege.where(id: params[:new_user_privilege]).first
            @target_user.user_privilege = new_user_privilege unless new_user_privilege.nil?

            if @target_user.valid?
              # and changes are valid
              @target_user.save
              format.json {
                render :json => reply(true, '', 'user', @target_user)
              }
            else
              # and changes are invalid
              format.json {
                render :json => reply(false, t(:bad_privilegies))
              }
            end
          end
        else
          # and user is not an admin
          format.json {
            render :json => reply(false, t(:bad_privilegies))
          }
        end
      else
        # user wants to edit his profile
        unless ((!params[:new_password_one].nil? && !params[:new_password_two].nil?) || (!params[:new_password_one].empty? && !params[:new_password_two].empty?)) && (params[:new_password_one] == params[:new_password_two])
          # and the passwords do not match!
          format.json {
            render :json => reply(false, t(:bad_password))
          }
        end

        current_user.password = User.get_hash(params[:new_password_one]) unless params[:new_password_one].nil? || params[:new_password_one].empty? || (params[:new_password_one] != params[:new_password_two])
        current_user.email_alt = params[:new_email] unless params[:new_email].nil? || params[:new_email].empty?
        current_user.nickname = params[:new_nickname] unless params[:new_nickname].nil? || params[:new_nickname].empty?

        if current_user.valid?
          # and changes are valid
          current_user.save!
          format.json {
            render :json => reply(true, '', 'user', current_user)
          }
        else
          # and changes are invalid
          format.json {
            render :json => reply(false, t(:bad_arguments))
            return
          }
        end
      end
    end
  end

  def promote
    if (!params.has_key?(:user_id))
      # error processing bc no id has been specified
      render :json => reply(false, t(:missing_parameter))
    else
      # id has been specified
      user_to_promote = User.where(id: params[:user_id]).first
      if user_to_promote.nil?
        # attempt to promote a non-existing user?
        render :json => reply(false, t(:false_parameter))
      elsif user_to_promote.id == current_user.id
        render :json => reply(false, t(:impossible))
      else
        if user_to_promote.user_privilege_id == 1
          # attempt to promote a user that is already admin
          render :json => reply(false, t(:already_admin))
        else
          # attempt to promote a user properly
          user_to_promote.user_privilege_id=1
          if user_to_promote.valid?
            # changes are valid?
            user_to_promote.save
            render :json => reply(true, t(:user_promoted))
          else
            render :json => reply(false, t(:unknown_error))
          end
        end
      end
    end
  end

  def demote
    if (!params.has_key?(:user_id))
      # error processing bc no id has been specified
      render :json => reply(false, t(:missing_parameter))
    else
      # id has been specified
      user_to_demote = User.where(id: params[:user_id]).first
      if user_to_demote.nil?
        # attempt to demote a non-existing user?
        render :json => reply(false, t(:false_parameter))
      elsif user_to_demote.id == current_user.id
        render :json => reply(false, t(:impossible))
      else
        if user_to_demote.user_privilege_id == 0
          # attempt to demote a user that is already only user
          render :json => reply(false, t(:already_demoted))
        else
          # attempt to demote a user properly
          user_to_demote.user_privilege_id=1
          if user_to_demote.valid?
            # changes are valid?
            user_to_demote.save
            render :json => reply(true, t(:user_demoted))
          else
            render :json => reply(false, t(:unknown_error))
          end
        end
      end
    end
  end

  # this action shall execute only after is_admin filter
  def get_users
    respond_to do |format|
      format.json {
        page = extract_int params, :page
        search_by = params[:search_by]
        # if bad request
        if page.nil? || search_by.nil?
          render :json => reply(false, t(:missing_params))
        # if values are present but invalid
        elsif page < 0
          render :json => reply(false, t(:bad_params))
        # if everything is okay
        else
          per_page = Rails.application.config.PAGE_SIZE
          @users = User.where('username LIKE :search_by OR email LIKE :search_by', {search_by: "%#{search_by}%"})
          @total_such = @users.count
          @users = @users.offset((page-1)*per_page).limit(per_page)
          render :partial => 'user/users', :layout => false
        end
      }
      format.html {
        render :status => :method_not_allowed, :nothing => true
        return
      }
    end
  end
end
