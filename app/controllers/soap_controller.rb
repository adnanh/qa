class SoapController < ApplicationController
  soap_service namespace: 'urn:WashOut'

  def c_priv
  end

  def r_priv
  end

  def u_priv
  end

  def d_priv
  end

  soap_action 'c_log',
              :args => {:message => :string },
              :return => {:success => :string}
  def c_log
    if(params[:message].nil?)
      Log.log(:message)
      render :soap => {:success => :false.to_s}
    else
      render :soap => {:success => :true.to_s}
    end
  end

  soap_action 'r_log',
      :arg => {},
      :return => {:logs => :string }

  def r_log
    lgs = Log.all
    render :soap => {:logs => lgs.to_s}
  end
end
