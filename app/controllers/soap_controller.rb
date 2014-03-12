class SoapController < ApplicationController
  soap_service namespace: 'urn:WashOut'

  soap_action 'c_priv',
              :args => {:name => :string, :description => :string },
              :return => { :privilege => {:id => :integer, :name => :string, :description => :string} }
  def c_priv
    privilege = UserPrivilege.new(:name => params[:name], :description => params[:description])

    begin
      privilege.save!
    rescue ActiveRecord::RecordInvalid
      render :soap => nil
      return
    end

    render :soap => { :privilege => {:id => privilege.id, :name => privilege.name, :description => privilege.description} }
    return
  end

  def r_priv
  end

  def u_priv
  end

  def d_priv
  end

  def c_log
  end

  def r_log
  end
end
