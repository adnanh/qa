module QaHelper
 require 'sanitize'
  def is_admin_or_author?(user, item)
    if user.nil? || !user.instance_of?(User)
      return false
    end

    if item.instance_of?(Question) || item.instance_of?(Answer)
      if user.user_privilege_id == Rails.application.config.ADMIN_PRIV
        return true
      else
        return user.id == item.author_id
      end
    else
      return false
    end
  end

  def concatenate_edit(original, append)
    return original + "\nEDIT:\n" + append
  end

  def do_sanitize_qa_content(content)
    return Sanitize.clean(content, :elements => %w(b i pre br code a img li ul ol p h1 h2 blockquote), :attributes => {'img' => ['src'], 'a' =>['href']})
  end

  def notify_followers_on_new_question(question)
    tags = question.tags.split(';')
    messaged_users = []

    tags.each do |tag|
      followings = Following.where(tag: tag)

      followings.each do |following|
        user_who_follows = following.user
        # dont notify user of his own question lol
        if question.author.id == user_who_follows.id
          next
        end

        # if we didnt message this user
        if !messaged_users.include? user_who_follows.id
          message = PrivateMessage.new(
              :title => 'New question with tag(s) you are following has been posted.',
              :content => "Link to question: <a href=\"http://#{request.host_with_port}/#/q/#{question.id.to_s}\">Link</a>",
              :sender_id => question.author.id,
              :receiver_id => user_who_follows.id,
              :sender_status => 2,
              :receiver_status => 0)
          message.save
          messaged_users.push user_who_follows.id
        end


      end
    end
  end

  def notify_op_on_new_answer(answer)
    # skip if user answered on his own question
    if answer.author.id == answer.question.author.id
      return
    end

    message = PrivateMessage.new(
        :title => 'New answer to your question has been posted.',
        :content => "Link to answer: <a href=\"http://#{request.host_with_port}/#/q/#{answer.question.id.to_s}/a/#{answer.id.to_s}\">Link</a>",
        :sender_id => answer.author.id,
        :receiver_id => answer.question.author.id,
        :sender_status => 2,
        :receiver_status => 0)
    message.save
  end
end
