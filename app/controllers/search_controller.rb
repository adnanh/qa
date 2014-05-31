class SearchController < ApplicationController
  def search_questions
    respond_to do |format|
      format.json{
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

  def search_similar_questions
    respond_to do |format|
      format.json {
        question_id = extract_int params, :question_id
        # if bad or non existant param
        if question_id.nil?
          render :json => reply(false, t(:missing_params))
        else
          # if param is okay, get question in question (no pun intended)
          question = Question.where(id:question_id).first
          # no such question?
          if question.nil?
            render :json => reply(false, t(:no_such_question))
          else
            # if question exists
            search_criteria_title = question.tags.gsub(/;/,' ')
            search_criteria_tags = question.title
            q1 = Question.search(search_criteria_title).where('id != :id',{id:question_id}).offset(0).limit(Rails.application.config.PAGE_SIZE)
            q2 = Question.search(search_criteria_tags).where('id != :id', {id: question_id}).offset(0).limit(Rails.application.config.PAGE_SIZE)
            @questions = (q1+q2).uniq
            @total_such = @questions.count
         #   @questions = @questions.offset(0).limit(Rails.application.config.PAGE_SIZE)
            render :partial => 'question/questions', :layout => false
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
