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
          search_criteria = params[:search_by]
          per_page = Rails.application.config.PAGE_SIZE
          @questions = Question.where("tags LIKE :search_criteria OR title LIKE :search_criteria",  {search_criteria: "%#{search_criteria}%"})
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
