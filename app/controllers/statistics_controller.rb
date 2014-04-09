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


  # requires admin
  # input - starting datetime
  # output - standard + response {kvp's day,answers}
  def answers_daily
    respond_to do |format|
      format.json {
        puts params
        if (!params.has_key?(:start_date))
          render :json => reply(false, t(:missing_params))
        else
          # date is specified
          results = ComplexQueries.answers_daily params[:start_date]
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
  # input -none
  # output - standard + response {answered vs unanswered questions}
  def answered_distribution
    respond_to do |format|
      format.json {
          results = ComplexQueries.answered_vs_unanswered
          if results.nil?
            render :json => reply(false, t(:unknown_error))
          else
            arr = []
            results.each{
                |h|
              arr.append({answered: h[0].to_i, unanswered: h[1]})
            }
            render :json => reply(true,'','response',arr[0])
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

  def self.answers_daily(start_date)
    self.connection.execute(sanitize_sql(['SELECT DATE(created_at) as date_result, count(*) FROM answers WHERE created_at > DATE(?) GROUP BY DAY(created_at) ORDER BY date_result ASC', start_date]))
  end

  def self.answered_vs_unanswered
    sql =
    self.connection.execute('select
                                    (select count(*) from questions where id not in (select distinct question_id from answers)) as UnansweredQuestions,
                                    count(distinct(a.question_id)) as Answered
                                    from questions q
                                      inner join answers a
                                        on q.id = a.question_id');
  end
end

