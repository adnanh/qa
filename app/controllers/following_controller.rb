class FollowingController < ApplicationController
  before_filter :require_logged_in

  def get_following_tags
    respond_to do |format|
      format.json {
        # get current user's followings
        followings = current_user.followings

        render :json => reply(true, 'Loaded user\'s follows.', 'response', followings.as_json(:except => [:updated_at, :created_at, :user_id]))
      }
      format.html {
        render :status => :method_not_allowed, :nothing => true
        return
      }
    end
  end

  def create_following_tag
    respond_to do |format|
      format.json {
        following = Following.new
        following.user_id = current_user.id
        following.tag = params[:tag]

        if !following.valid?
          render :json => reply(false, 'Invalid tag.')
        else
          if following.save
            render :json => reply(true, 'Successfully started following tag '+params[:tag]+'.', 'following_id', following.id)
          else
            render :json => reply(false, 'Failed to start following tag. Try again later.')
          end
        end

      }
      format.html {
        render :status => :method_not_allowed, :nothing => true
        return
      }
    end
  end

  def delete_following_tag
    respond_to do |format|
      format.json {
        # get id to delete
        following_id = extract_int params, :following_id

        # if bad request
        if following_id.nil?
          render :json => reply(false, t(:missing_params))
        else
          following = Following.where(id: following_id, user_id: current_user.id).first

          # no such record?
          if following.nil?
            render :json => reply(false, 'Nothing to delete.')
          else
            # if there is a record, delete it
            following.destroy
            # if deletion successful
            if following.destroyed?
              render :json => reply(true, 'You no longer follow the tag: '+following.tag+'.')
            # if deletion failed
            else
              render :json => reply(false, 'Failed to unfollow tag.' )
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
