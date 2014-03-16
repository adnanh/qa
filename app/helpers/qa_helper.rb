module QaHelper
  def is_admin_or_author?(author, item, type)
    if author.nil?
      return false
    elsif author.user_privilege_id == codes.ADMIN_PRIV
      return true
    elsif item.instance_of? Question

    elsif item.instance_of? Answer

    else
      return false
    end
  end
end
