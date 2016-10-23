module ApplicationHelper
  def full_title page_title = ""
    base_title = t ".base_title"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def message_fa_class message_type
    type = Settings.MESSAGE_TYPES
    case message_type
    when type[:success]
      "fa-check-circle-o"
    when type[:danger]
      "fa-warning"
    when type[:warning]
      "fa-exclamation-circle"
    else
      "fa-info-circle"
    end
  end
end
