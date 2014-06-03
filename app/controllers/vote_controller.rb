class VoteController < ApplicationController
  before_filter :require_logged_in, :except => []

  def vote_question
    respond_to do |format|
      format.json {
        puts params
        usr_created = extract_int params, :user_created
    if (!params.has_key?(:item_id)) || usr_created.nil?
      # if not, we alert the user
      render :json => reply(false, t(:missing_params))
    elsif (!(params[:item_id].is_integer?)) || current_user.id === usr_created
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
          vote_temp.save

          item_to_upvote.author.karma = item_to_upvote.author.karma + (vote_temp.value ? Rails.application.config.KARMA_UPVOTE_POINTS : Rails.application.config.KARMA_DOWNVOTE_POINTS)
          item_to_upvote.author.save

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
        cur_user = current_user.id
        usr_created = extract_int params, :user_created
    if (!params.has_key?(:item_id)) || usr_created.nil?
      # if not, we alert the user
      render :json => reply(false, t(:missing_params))
      elsif (!(params[:item_id].is_integer?)) || cur_user === usr_created
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
          vote_temp.save

          item_to_upvote.author.karma = item_to_upvote.author.karma + (vote_temp.value ? Rails.application.config.KARMA_UPVOTE_POINTS : Rails.application.config.KARMA_DOWNVOTE_POINTS)
          item_to_upvote.author.save
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