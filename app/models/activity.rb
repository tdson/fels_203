class Activity < ApplicationRecord
  belongs_to :user

  enum activity_types: [:start_lesson, :finish_lesson, :follow, :unfollow]

  scope :user_activities, ->user do
    where "user_id = :user_id OR user_id IN (SELECT followed_id
      FROM relationships WHERE follower_id = :user_id)", user_id: user.id
  end
  scope :newest, ->{order created_at: :desc}

  def get_target_model
    self.action_type < Activity.activity_types[:follow] ? Lesson : User
  end

  def get_object_user
    User.find_by_id self.user_id
  end

  def get_target_user
    User.find_by_id self.target_id
  end

  def get_target_lesson
    Lesson.includes(:category).find_by_id self.target_id
  end

  def is_valid?
    return false unless get_object_user
    if get_target_model == User
      return false unless get_target_user
    else
      return false unless get_target_lesson
    end
    true
  end
end
