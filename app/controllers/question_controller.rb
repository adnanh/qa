class QuestionController < ApplicationController
  include QaHelper

  before_filter :require_logged_in, :except => [:get]
  before_filter :require_admin, :only => [:delete]

  # request is filtered by require_logged_in
  # cannot be logged in if is banned, so thats dealt with
  def create
    respond_to do |format|
      format.json {
        # validates_presence_of :author, :title, :content, :tags, :open, :views
        question = Question.new
        question.author_id= current_user.id
        question.title= params[:title]
        question.content= params[:content]
        question.tags= params[:tags]
        question.open= true
        question.views= 0

        if !question.valid?
          render :json => reply(false, t(:missing_params))
        else

          if question.save
            render :json => reply(true, t(:question_creation_successful))
          else
            render :json => reply(false, t(:question_creation_failed))
          end
        end
      }
      format.html {
        render :status => :method_not_allowed, :nothing => true
        return
      }
    end
  end

  #gets question by its ID with all answers
  def get
    respond_to do |format|
      format.json {
        question_id = extract_int params, :question_id

        #if bad request
        if question_id.nil?
          render :json => reply(false, t(:missing_params))

        #if okay
        else
          @question = Question.where(id: question_id).first

          if @question.nil?
            render :json => reply(false, t(:no_such_question))
          else
            # fetch all the data
            @user = current_user
            @qvotes = @question.votes
            @uvote
            @uvote = @qvotes.where(user_id: @user.id).first unless @user.nil?

            @answers = @question.answers

            # custom render
            render :partial => 'question', :layout => false
          end
        end
      }
      format.html {
        render :status => :method_not_allowed, :nothing => true
        return
      }
    end
  end

  # requires admin or author
  def update
    respond_to do |format|
      format.json {
        question_id = extract_int params, :question_id

        # if bad request
        if question_id.nil?
          render :json => reply(false, t(:missing_params))

        # if okay
        else
          question = Question.where(id: question_id).first

          # no such record ?
          if question.nil?
            render :json => reply(false, t(:no_such_question))
          # user who is attempting to edit question isnt author nor admin?
          elsif !is_admin_or_author?(current_user,question)
            render :json => reply(false, t(:question_edit_insufficient_privileges))
          # everything is okay?
          else
            question.title= params[:title] unless params[:title].nil?
            question.content= concatenate_edit(question.content, params[:content]) unless params[:content].nil?
            question.tags= params[:tags] unless params[:tags].nil?

            # if is admin, enable "open" change
            if is_admin? && !params[:open].nil? && !params[:description].nil?
              question.open= params[:open]
              question.status_description= params[:description]
            end

            question.editor_id= current_user.id

            if !question.valid?
              render :json => reply(false, t(:question_edit_invalid_new_values))
            else
              if question.save
                Log.log("User  #{current_user.username} (UID = #{current_user.id}) edited question '#{question.id}' by author with UID = #{question.author.id}",request.remote_ip)
                render :json => reply(true, t(:question_editing_successful))
              else
                render :json => reply(false, t(:question_editing_failed))
              end
            end
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
  def delete
    respond_to do |format|
      format.json {
        # get question id
        question_id = extract_int params, :question_id

        # if bad request
        if question_id.nil?
          render :json => reply(false, t(:missing_params))
        else
          question = Question.where(id: question_id).first

          # no such record?
          if question.nil?
            render :json => reply(false, t(:no_such_question))
          else
            # if there is a record, delete it
            question.destroy
            # if deletion successful
            if question.destroyed?
              Log.log("User with admin privileges #{current_user.username} (UID = #{current_user.id}) deleted question '#{question.id}' by author with UID = #{question.author.id}", request.remote_ip)
              render :json => reply(true, t(:question_deletion_successful))
            # if deletion failed
            else
              render :json => reply(false, t(:question_deletion_failed) )
            end
          end
        end
      }
      format.html {
      }
    end
  end

  def open
    respond_to do |format|
      format.json {

      }
      format.html {
        render :status => :method_not_allowed, :nothing => true
        return
      }
    end
  end

  def close
    respond_to do |format|
      format.json {

      }
      format.html {
        render :status => :method_not_allowed, :nothing => true
        return
      }
    end
  end
end
