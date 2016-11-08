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

  def active_class link_path
    request.original_fullpath.include?(link_path) ? "active" : ""
  end

  def is_valid? activity
    activity.is_valid?
  end

  def get_user activity
    activity.get_object_user
  end

  def activity_user activity
    user = get_user activity
    link_to user.name, user
  end

  def activity_description activity
    descriptions = [t("activities.type_0"),
      t("activities.type_1"), t("activities.type_2"), t("activities.type_3")]
    descriptions[activity.action_type]
  end

  def link_to_activity_target activity
    model = activity.get_target_model
    if model == User
      user = activity.get_target_user
      link_to user.name, user
    else
      category = activity.get_target_lesson.category
      "#{t "activities.lesson"}
        #{link_to category.name, categories_path(q: category.name)}".html_safe
    end
  end

  def link_to_remove_field name, f
    f.hidden_field(:_destroy) + link_to_function(name, "remove_field(this)")
  end

  def link_to_add_field name, f, association
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for association, new_object,
      child_index: "new_#{association}" do |builder|
        render association.to_s.singularize + "_field", f: builder
    end
      link_to_function name,
        "add_field(this, \"#{association}\", \"#{j (fields)}\")"
  end

  def link_to_function name, *args, &block
    html_options = args.extract_options!.symbolize_keys
      function = block_given? ? update_page(&block) : args[0] || ""
      onclick = "#{"#{html_options[:onclick]};
    "if html_options[:onclick]}#{function}; return false;"
    href = html_options[:href] || "#"
    content_tag :a, name, html_options.merge(href: href, onclick: onclick)
  end

  def active_tab params, tab_id
    Settings.active_class if params[:tab] == tab_id
  end
end
