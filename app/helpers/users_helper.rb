module UsersHelper
  def admin?
    current_user.nil? ? false : current_user.admin?
  end

  def avatar_for user, options = {size: Settings.AVATAR_DEFAULT_SIZE}
    size = options[:size]
    avatar_path = user.avatar? ? user.avatar.url : Settings.AVATAR_DEFAULT
    image_tag avatar_path, alt: user.name, class: "avatar", size: size
  end
end
