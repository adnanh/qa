class RestController < ApplicationController
  def c_priv
    respond_to do |format|
      format.json {
        if (!params[:name].nil? && !params[:description].nil?)
          privilege = UserPrivilege.new(:name => params[:name], :description => params[:description])

          begin
            privilege.save!
          rescue ActiveRecord::RecordInvalid
            render :status => :bad_request, :nothing => true
            return
          end

          render :json => privilege
          return
        else
          render :status => :bad_request, :nothing => true
          return
        end
      }

      format.html {
        render :status => :method_not_allowed, :nothing => true
        return
      }
    end
  end

  def r_priv
    respond_to do |format|
      format.json {
        if (params[:id].nil?)
          privileges = UserPrivilege.all

          if privileges.nil?
            render :status => :not_found, :nothing => true
            return
          else
            render :json => privileges
            return
          end
        else
          privilege = UserPrivilege.find_by(:id => params[:id])

          if privilege.nil?
            render :status => :not_found, :nothing => true
            return
          else
            render :json => privilege
            return
          end
        end
        return
      }

      format.html {
        render :status => :method_not_allowed, :nothing => true
        return
      }
    end
  end

  def u_priv
    respond_to do |format|
      format.json {
        if params[:privilege_id].nil?
          render :json => {:success => false}
          return
        end

        priv = UserPrivilege.where(id: params[:privilege_id]).first
        if priv.nil?
          render  :json => {:success => false }
        else
          priv.name = params[:new_name] unless params[:new_name].nil?
          priv.description = params[:new_description] unless params[:new_description].nil?
          if priv.save
            render :json => {:success => true }
          else
            render :json => {:success => false}
          end
        end
      }

      format.html {
        render :status => :method_not_allowed, :nothing => true
        return
      }
    end
  end

  def d_priv
    respond_to do |format|
      format.json {
        if params[:privilege_id].nil?
          render :json => {:success => false}
          return
        end
        priv = UserPrivilege.where(id: params[:privilege_id]).first
        if priv.nil?
          render :json => { :success => false }
        else
          priv.destroy
          if priv.destroyed?
            render :json => {:success => true}
          else
            render :json => {:success => false}
          end
        end
      }

      format.html {
        render :status => :method_not_allowed, :nothing => true
        return
      }
    end
  end

  def c_log
    if(params[:message].nil?)
      render :json => {:success => :false}
    else
      Log.log(params[:message], request.remote_ip)
      render :json => {:success => :true}
    end
  end

  def r_log
    logs = Log.all
    render :json => logs
  end
end
