class StatisticsController < ApplicationController
  before_filter :require_admin

  # requires admin
  # input - starting datetime
  # output - standard + response {kvp's day,registrations}
  def registrations_daily
    respond_to do |format|
      format.json {
        puts params
        if (!params.has_key?(:start_date))
          render :json => reply(false, t(:missing_params))
        else
          # date is specified
          results = ComplexQueries.registrations_daily params[:start_date]
          if results.nil?
            render :json => reply(false, t(:unknown_error))
          else
            arr = []
            results.each{
                |h|
              arr.append({day: h[0], count: h[1]})
            }
            render :json => reply(true,'','response',arr)
          end
        end
      }
      format.html {
        render :status => :method_not_allowed, :nothing => true
        return
      }
    end
  end

  # requires admin
  # input -starting datetime
  # output - standard + response {verified vs nonverified users double}
  def registrations_distribution
    respond_to do |format|
      format.json {
        if (!params.has_key?(:start_date))
          render :json => reply(false, t(:missing_params))
        else
          # date is specified
          results = ComplexQueries.registrations_distribution params[:start_date]
          if results.nil?
            render :json => reply(false, t(:unknown_error))
          else
            arr = []
            results.each{
                |h|
              arr.append({confirmed: h[0].to_i, total: h[1]})
            }
            render :json => reply(true,'','response',arr[0])
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

# A-grade awesomeness
class ComplexQueries < ActiveRecord::Base
  def self.registrations_daily(start_date)
    self.connection.execute(sanitize_sql(['SELECT DATE(confirmation_sent_at) as date_result, count(*) FROM users WHERE confirmation_sent_at > DATE(?) GROUP BY DAY(confirmation_sent_at) ORDER BY date_result ASC', start_date]))
  end

  def self.registrations_distribution(start_date)
    self.connection.execute(sanitize_sql(['SELECT sum(CASE WHEN confirmed_at IS NOT NULL THEN 1 ELSE 0 END), count(*) FROM users WHERE confirmation_sent_at > DATE(?)', start_date]))
  end
end

