class LogController < ApplicationController

  include ApplicationHelper

  def get_logs
    #this action shall be executed only after the require_admin
    #so, user is admin
  respond_to do |format|
    if (!params.has_key?(:page) || !params.has_key?(:oreder_param) || !params.has_key?(:content_match))
      # if there is a parameter missing
      format.json{render :json => reply(false,t(:missing_parameter))}
    elsif ((params[:direction]!='newer' && params[:direction]!='older') || !(params[:demarcation_id].is_integer?) || Integer(params[:demarcation_id])<-1)
      format.json{render :json => reply(false,t(:bad_parameters))}
    else
      # all parameters are present and valid, let's filter this

      # first we get the default number of items to load
      items_to_load = Rails.application.config.DEFAULT_NUMBER_OF_ITEMS_TO_LOAD

      #then we read all them params into local variables
      page_id = params[:page]
      direction = params[:order_param]
      match = params[:content_match]

      # demarcation_id of -1 => initial load (filter IS applied)
      if filter_by==-1
        @logs = Log.where('description LIKE :match OR ip_address LIKE :match',{match: "%#{match}%"}).order('created_at').limit(items_to_load).reverse_order
        # we are getting newer items than the one sent as parameter AND applying filter
      elsif direction=='newest_first'
        @logs= Log.where('id > :page_id AND (description LIKE :match OR ip_address LIKE :match)', {page_id: page_id, match: "%#{match}%"}).order('created_at').limit(items_to_load).reverse_order
        # we are getting older items than the one sent as parameter AND applying filter
      else
        @logs= Log.where('id < :page_id AND (description LIKE :match OR ip_address LIKE :match)', {page_id: page_id, matchy: "%#{match}%"}).order('created_at').limit(items_to_load)
      end
      format.json{render :json => reply(true,'','logs',@logs)}
    end
  end
  end
end