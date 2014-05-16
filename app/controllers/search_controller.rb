class SearchController < ApplicationController
  before_filter :require_logged_in, :except => []

  def search_questions
    respond_to do |format|
      format.json{
        puts params
        page = extract_int params, :page
        subqueries = []
        if (params.has_key?(:search_condition))
          params[:search_condition].each do |element|
            subqueries.append('tags LIKE %'+element+'% or');
          end
          subqueries.append('title LIKE %'+:search_condition+'%');
          subqueries.join(' ');
        else
          query = 'select * from questions  where' + subqueries
          results = self.connection.execute(query);
          per_page = Rails.application.config.PAGE_SIZE
          @questions = results
          @total_such = @questions.count
          @questions = @questions.offset((page-1)*per_page).limit(per_page)
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