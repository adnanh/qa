class SoapController < ApplicationController
  soap_service namespace: 'urn:WashOut'

  class Privilege < WashOut::Type
    map :privilege_id => :integer, :name => :string, :description => :string
  end

  class LogSOAP < WashOut::Type
    map :ip_address => :string, :datetime => :string, :description => :string
  end

  # For create
  #<?xml version="1.0" encoding="utf-8"?>
  #    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  #<soap:Body>
  #<c_priv xmlns="urn:WashOut">
  #<privilege>
  #<privilege_id></privilege_id>
  #         <name>blah</name>
  #<description>blah</description>
  #       </privilege>
  #</c_priv>
  #   </soap:Body>
  #</soap:Envelope>

  soap_action 'c_priv',
              :args => { :privilege => Privilege },
              :return => { :privilege => Privilege }
  def c_priv

    if params[:privilege].nil?
      render :soap => { :privilege => nil }
      return
    end

    privilege = UserPrivilege.new(:name => params[:privilege][:name], :description => params[:privilege][:description])

    begin
      privilege.save!
    rescue ActiveRecord::RecordInvalid
      render :soap => { :privilege => nil }
      return
    end

    render :soap => { :privilege => { :privilege_id => privilege.id, :name => privilege.name, :description => privilege.description } }
    return
  end

  soap_action 'r_priv',
              :args => { :privilege_id => :integer },
              :return => { :privileges => { :privilege => [Privilege] } }
  def r_priv
    if !params[:privilege_id].nil?
      privileges = UserPrivilege.where(:id => params[:privilege_id])
    else
      privileges = UserPrivilege.all
    end

    privs = []

    privileges.each do |privilege|
      privs.push( {  :privilege_id => privilege.id, :name => privilege.name, :description => privilege.description } )
    end

    render :soap => { :privileges => { :privilege => privs } }

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
              :return => {:success => :boolean}
  def c_log
    if(params[:message].nil?)
      Log.log(params[:message],request.ip)
      render :soap => {:success => :false}
    else
      render :soap => {:success => :true}
    end
  end

  soap_action 'r_log',
              :args => {},
              :return => { :logs => { :log => [Privilege] } }

  def r_log
      lgs = Log.all
      lgss = []
    lgs.each do |log|
      lgss.push( {  :ip_address => log.ip_address, :datetime => log.created_at, :description => log.description } )
    end
    render :soap => { :logs => { :log => lgss } }
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
