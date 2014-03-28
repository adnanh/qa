module QaHelper

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
end