class PrivateMessageController < ApplicationController
  QaHelper
  before_filter :require_logged_in, :except => []

  def create
    respond_to do |format|
      format.json {
        message = PrivateMessage.new(:title => params[:title], :content => do_sanitize_qa_content(params[:content]), :sender_id => current_user.id, :receiver_id => params[:receiver_id], :sender_status => 1, :receiver_status => 0)

        if message.valid? && (message.receiver_id != current_user.id)
          message.save
          render :json => reply(true, 'Message successfully sent', 'message', message)
        else
          render :json => reply(false, 'You must supply valid values for message parameters')
        end
      }
    end
  end

  def delete
    respond_to do |format|
      format.json {
        message = PrivateMessage.where(["(id = ?) AND ((sender_id = ? AND sender_status != 2) OR (receiver_id = ? AND receiver_status != 2))", params[:message_id], current_user.id, current_user.id]).first

        if message.nil?
          render :json => reply(false, 'You must supply valid values for message parameters')
        else
          if message.sender_id == current_user.id
            message.sender_status = 2
          end
          if message.receiver_id == current_user.id
            message.receiver_status = 2
          end

          if (message.sender_status_id == 2) && (message.receiver_status_id == 2)
            message.delete
          else
            message.save
          end

          render :json => reply(true, 'Message successfully deleted')
        end
      }
    end
  end

  def inbox
    respond_to do |format|
      format.json {
        messages = PrivateMessage.where(["receiver_id = ? AND receiver_status != 2", current_user.id]).order(created_at: :desc)

        formatted_messages = []

        messages.each do |message|
          sender = User.find(message.sender_id)
          formatted_messages.push({ :id => message.id, :title => message.title, :content => message.content, :sender_id => message.sender_id, :sender_username => sender.username, :sent_at => message.created_at, :status => message.receiver_status })
        end

        render :json => reply(true, '', 'inbox', formatted_messages)
      }
    end
  end

  def outbox
    respond_to do |format|
      format.json {
        messages = PrivateMessage.where(["sender_id = ? AND sender_status != 2", current_user.id]).order(created_at: :desc)

        formatted_messages = []

        messages.each do |message|
          receiver = User.find(message.receiver_id)
          formatted_messages.push({ :id => message.id, :title => message.title, :content => message.content, :receiver_id => message.receiver_id, :receiver_username => receiver.username, :sent_at => message.created_at })
        end

        render :json => reply(true, '', 'outbox', formatted_messages)
      }
    end
  end

  def get
    respond_to do |format|
      format.json {
        message = PrivateMessage.where(["(id = ?) AND (receiver_id = ? AND receiver_status != 2)", params[:message_id], current_user.id]).first

        if message.nil?
          render :json => reply(false, 'You must supply valid values for message parameters')
        else
          if message.receiver_status_id == 0
            message.receiver_status = 1
            message.save
          end

          sender = User.find(message.sender_id)

          formatted_message = { :id => message.id, :title => message.title, :content => message.content, :sender_id => message.sender_id, :sender_username => sender.username, :sent_at => message.created_at }

          render :json => reply(true, '', 'message', formatted_message)
        end
      }
    end
  end

  def check
    respond_to do |format|
      format.json {
        message = PrivateMessage.where(["receiver_id = ? AND receiver_status = 0", current_user.id])
        render :json => reply(true, '', 'count', message.size)
      }
    end
  end

  def suggest_users
    respond_to do |format|
      format.json {
        if (params[:filter_string])
          matched_users = User.where('username LIKE :filter_string', {filter_string: "#{params[:filter_string]}%"})
          users = []

          matched_users.each do |user|
            users.push({id: user.id, nickname: user.username})
          end

          render :json => reply(true, '', 'users', users)
        else
          render :json => reply(false, 'You must specify the filter string.', 'users', [])
        end
      }

      format.html { render :nothing => true }
    end
  end
end
