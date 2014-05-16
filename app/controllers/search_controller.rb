class SearchController < ApplicationController
  before_filter :require_logged_in, :except => [:search_questions]

  def search_questions
    respond_to do |format|
      format.json{
        puts params
        page = extract_int params, :page
        if (!params.has_key?(:search_by))
          render :json => reply(false, t(:missing_params))
        else
          subqueries = []
        if(!params[:search_by] == "")
          params[:search_by].each do |element|
            subqueries.append('tags LIKE %'+element+'% or');
          end
          subqueries.append('title LIKE %'+params[:search_by]+'%');
          subqueries.join(' ');
        end
          if(!subqueries.empty?)
          query = 'select * from questions where' + subqueries
          else
            query = 'select * from questions'
          end
          results = SearchQueries.search_questions(query);
          per_page = Rails.application.config.PAGE_SIZE
          @questions = results
          @total_such = @questions.count
    #      @questions = @questions.offset((page-1)*per_page).limit(per_page)
          render :partial => 'question/questions', :layout => false
        end
      }
        format.html {
          render :status => :method_not_allowed, :nothing => true
          return
        }
    end
  end

end

class SearchQueries < ActiveRecord::Base

  def self.search_questions(query)
    self.connection.execute(query);
  end
end