class VoteController < ApplicationController
  before_filter :require_logged_in, :except => []

  def vote_question
    if (!params.has_key?(:item_id))
      # if not, we alert the user
      render :json => {success:false, message:'Nedostaje parametar.'}
    elsif (!(params[:item_id].is_integer?))
      # if parameter exists and is of incorrect datatype
      render :json => {success:false, message:'ID mora biti integer.'}
    else
      item_to_upvote = Question.where(id: params[:item_id]).first
      newValue = params[:value]
      item_votes = Vote.where("disqsable_id = ? AND disqsable_type = ? AND user_id = ?",item_to_upvote.id, 'Question', mod.id ).first

      if(item_votes.nil?)

        vote_temp = Vote.new
        vote_temp.disqsable = item_to_upvote
        vote_temp.value = newValue
        vote_temp.user_id = current_user.id

        if(vote_temp.valid?)
          vote_temp.save()
          render :json => {success:true, message:'Glasanje uspjesno.'}
        end
      else
        if((item_votes.value==1 && newValue==-1)||(item_votes.value==-1 && newValue==1))
          vote_temp = Vote.new
          vote_temp.disqsable = item_to_upvote
          vote_temp.value = vote_temp.value + newValue
          vote_temp.user_id = mod.id

          if(vote_temp.valid?)
            vote_temp.save()
            render :json => {success:true, message:'Glasanje uspjesno.'}
          end
        else
          render :json => {success:false, message:'Vec ste dali glas.'}
        end
      end

    end
  end

  def vote_answer
    if (!params.has_key?(:item_id))
      # if not, we alert the user
      render :json => {success:false, message:'Nedostaje parametar.'}
    elsif (!(params[:item_id].is_integer?))
      # if parameter exists and is of incorrect datatype
      render :json => {success:false, message:'ID mora biti integer.'}
    else
      item_to_upvote = Answer.where(id: params[:item_id]).first
      newValue = params[:value]
      item_votes = Vote.where("disqsable_id = ? AND disqsable_type = ? AND user_id = ?",item_to_upvote.id, 'Answer', mod.id ).first

      if(item_votes.nil?)

        vote_temp = Vote.new
        vote_temp.disqsable = item_to_upvote
        vote_temp.value = newValue
        vote_temp.user_id = current_user.id

        if(vote_temp.valid?)
          vote_temp.save()
          render :json => {success:true, message:'Glasanje uspjesno.'}
        end
      else
        if((item_votes.value==1 && newValue==-1)||(item_votes.value==-1 && newValue==1))
          vote_temp = Vote.new
          vote_temp.disqsable = item_to_upvote
          vote_temp.value = vote_temp.value + newValue
          vote_temp.user_id = mod.id

          if(vote_temp.valid?)
            vote_temp.save()
            render :json => {success:true, message:'Glasanje uspjesno.'}
          end
        else
          render :json => {success:false, message:'Vec ste dali glas.'}
        end
      end

    end
  end
end