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
  end

  def d_priv
  end

  def c_log
    if(params[:message].nil?)
      render :json => {:success => :false}
    else
      Log.log(:message)
      render :json => {:success => :true}
    end
  end

  def r_log
    logs = Log.all
    render :json => logs
  end
end
