class SoapController < ApplicationController
  soap_service namespace: 'urn:WashOut'

  class Privilege < WashOut::Type
    map :privilege_id => :integer, :name => :string, :description => :string
  end

  def c_priv
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


  def c_log
  end

  def r_log
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
