module UsersHelper
  def admin?
    current_user.nil? ? false : current_user.admin?
  end
end
