class VoteController < ApplicationController
  before_filter :require_logged_in, :except => []

  def vote_question
    respond_to do |format|
      format.json {
        puts params
    if (!params.has_key?(:item_id))
      # if not, we alert the user
      render :json => reply(false, t(:missing_params))
    elsif (!(params[:item_id].is_integer?))
      # if parameter exists and is of incorrect datatype
      render :json => reply(false, t(:bad_params))
    else
      item_to_upvote = Question.where(id: params[:item_id]).first
      newValue = params[:value]
      item_votes = Vote.where("disqsable_id = ? AND disqsable_type = ? AND user_id = ?",item_to_upvote.id, 'Question', current_user.id ).first

      if(item_votes.nil?)

        vote_temp = Vote.new
        vote_temp.disqsable = item_to_upvote
        vote_temp.value = newValue
        vote_temp.user_id = current_user.id

        if(vote_temp.valid?)
          vote_temp.save()
          render :json => reply(true, t(:voted))
        end
      else
          render :json => reply(false, t(:already_voted))
      end

    end
      }
      format.html {
        render :status => :method_not_allowed, :nothing => true
        return
      }
    end
  end

  def vote_answer
    respond_to do |format|
      format.json {
        puts params
    if (!params.has_key?(:item_id))
      # if not, we alert the user
      render :json => reply(false, t(:missing_params))
    elsif (!(params[:item_id].is_integer?))
      # if parameter exists and is of incorrect datatype
      render :json => reply(false, t(:bad_params))
    else
      item_to_upvote = Answer.where(id: params[:item_id]).first
      newValue = params[:value]
      item_votes = Vote.where("disqsable_id = ? AND disqsable_type = ? AND user_id = ?",item_to_upvote.id, 'Answer', current_user.id ).first

      if(item_votes.nil?)

        vote_temp = Vote.new
        vote_temp.disqsable = item_to_upvote
        vote_temp.value = newValue
        vote_temp.user_id = current_user.id

        if(vote_temp.valid?)
          vote_temp.save()
          render :json => reply(true, t(:voted))
        end
      else
          render :json => reply(false, t(:already_voted))
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