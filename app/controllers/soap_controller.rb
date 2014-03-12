class SoapController < ApplicationController
  soap_service namespace: 'urn:WashOut'

  class Privilege < WashOut::Type
    map :privilege_id => :integer, :name => :string, :description => :string
  end

  soap_action 'u_priv',
              :args => { :privilege => Privilege},
              :return => { :privilege => Privilege }
  def c_priv
    privilege = UserPrivilege.new(:name => params[:name], :description => params[:description])

    begin
      privilege.save!
    rescue ActiveRecord::RecordInvalid
      render :soap => { :error => true }
      return
    end

    soap_privilege = Privilege.new
    soap_privilege.privilege_id = privilege.id
    soap_privilege.name = privilege.name
    soap_privilege.description = privilege.description

    render :soap => soap_privilege
    return
  end

  def r_priv
  end

  soap_action 'u_priv',
              :args => { :privilege => Privilege},
              :return => {:success => :boolean }
  def u_priv
    if params[:privilege][:privilege_id].nil?
      render :soap => {:success => false}
      return
    end

    priv = UserPrivilege.where(id: params[:privilege][:privilege_id]).first
    if priv.nil?
      render  :soap => {:success => false }
    else
      priv.name = params[:privilege][:name] unless params[:privilege][:name].nil?
      priv.description = params[:privilege][:description] unless params[:privilege][:description].nil?
      priv.save
      render :soap => {:success => true }
    end
  end

  soap_action 'd_priv',
              :args => { :privilege => Privilege},
              :return => { :success => :boolean }
  def d_priv
    if params[:privilege][:privilege_id].nil?
      render :soap => {:success => false}
      return
    end
    priv = UserPrivilege.where(id: params[:privilege][:privilege_id]).first
    if priv.nil?
      render :soap => { :success => false }
    else
      priv.destroy
      if priv.destroyed?
        render :soap => {:success => true}
      else
        render :soap => {:success => false}
      end
    end
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

# yo yo yo this is how you call this mofo @ host:port/soap/action
# <?xml version="1.0" encoding="utf-8"?>
#   <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
#     <soap:Body>
#       <d_priv xmlns="urn:WashOut">
#         <privilege>
#           <privilege_id>5</privilege_id>
#         </privilege>
#       </d_priv>
#     </soap:Body>
# </soap:Envelope>
