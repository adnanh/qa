class AnswerController < ApplicationController
  include QaHelper

  before_filter :require_logged_in
  before_filter :require_admin, :only => [:delete]

  # creates new answer for question
  def create
    respond_to do |format|
      format.json {
        answer = Answer.new
        answer.author = current_user
        answer.question_id = extract_int params, :question_id
        answer.content = params[:content]
        answer.accepted = false

        if !answer.valid?
          render :json => reply(false, t(:missing_params))
        else
          if answer.question.blank?
            render :json => reply(false, t(:answer_creation_invalid_question))
          elsif answer.save
            render :json => reply(true, t(:answer_creation_successful), 'answer_id', answer.id)
          else
            render :json => reply(false, t(:answer_creation_failed))
          end
        end
      }
      format.html {
        render :status => :method_not_allowed, :nothing => true
        return
      }
    end
  end

  # updates existing answer for question
  def update
    respond_to do |format|
      format.json {
        # get question & answer id
        question_id = extract_int params, :question_id
        answer_id = extract_int params, :answer_id

        # if bad request
        if question_id.nil? || answer_id.nil?
          render :json => reply(false, t(:missing_params))

          # if okay
        else
          answer = Answer.where(id: answer_id, question_id: question_id).first

          # no such record ?
          if answer.nil?
            render :json => reply(false, t(:no_such_answer))
            # user who is attempting to edit answer isnt author nor admin?
          elsif !is_admin_or_author?(current_user,answer)
            render :json => reply(false, t(:answer_edit_insufficient_privileges))
            # everything is okay?
          else
            answer.content= concatenate_edit(answer.content, params[:content]) unless params[:content].nil?
            answer.editor_id= current_user.id

            if !answer.valid?
              render :json => reply(false, t(:answer_edit_invalid_new_values))
            else
              if answer.save
                Log.log("User #{current_user.username} (UID = #{current_user.id}) edited answer'#{answer.id}' by author with UID = #{answer.author.id}",request.remote_ip)
                render :json => reply(true, t(:answer_editing_successful))
              else
                render :json => reply(false, t(:answer_editing_failed))
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

  # deletes existing answer for question, isadmin only
  def delete
    respond_to do |format|
      format.json {
        # get question & answer id
        question_id = extract_int params, :question_id
        answer_id = extract_int params, :answer_id

        # if bad request
        if answer_id.nil?
          render :json => reply(false, t(:missing_params))
        else
          answer = Answer.where(id: answer_id, question_id: question_id).first

          # no such record?
          if answer.nil?
            render :json => reply(false, t(:no_such_answer))
          else
            # if there is a record, delete it
            answer.destroy
            # if deletion successful
            if answer.destroyed?
              Log.log("User with admin privileges #{current_user.username} (UID = #{current_user.id}) deleted answer '#{answer.id}' by author with UID = #{answer.author.id}", request.remote_ip)
              render :json => reply(true, t(:answer_deletion_successful))
            # if deletion failed
            else
              render :json => reply(false, t(:answer_deletion_failed) )
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

  # picks existing answer for question as accepted, isauthor only
  def pick
    respond_to do |format|
      format.json {
        # get question & answer id
        question_id = extract_int params, :question_id
        answer_id = extract_int params, :answer_id

        # if bad request
        if question_id.nil? || answer_id.nil?
          render :json => reply(false, t(:missing_params))
        else
          answer = Answer.where(id: answer_id, question_id: question_id).first

          # no such record?
          if answer.nil?
            render :json => reply(false, t(:no_such_answer))
          # record exists
          elsif !is_admin_or_author?(current_user,answer)
            render :json => reply(false, t(:answer_pick_insufficient_privileges))
          else
            # accept it
            answer.accepted = true unless answer.accepted?

            if answer.save
              render :json => reply(true, t(:answer_pick_success))
            else
              render :json => reply(false, t(:answer_pick_failure))
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

  # unpicks existing accepted answer for question, isauthor only
  def unpick
    respond_to do |format|
      format.json {
        # get question & answer id
        question_id = extract_int params, :question_id
        answer_id = extract_int params, :answer_id

        # if bad request
        if question_id.nil? || answer_id.nil?
          render :json => reply(false, t(:missing_params))
        else
          answer = Answer.where(id: answer_id, question_id: question_id).first

          # no such record?
          if answer.nil?
            render :json => reply(false, t(:no_such_answer))
            # record exists
          elsif !is_admin_or_author?(current_user,answer)
            render :json => reply(false, t(:answer_unpick_insufficient_privileges))
          else
            # de-accept it :D
            answer.accepted = false unless !answer.accepted?

            if answer.save
              render :json => reply(true, t(:answer_unpick_success))
            else
              render :json => reply(false, t(:answer_unpick_failure))
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
end