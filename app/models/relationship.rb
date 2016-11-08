class Relationship < ApplicationRecord
  belongs_to :follower, class_name: User.name
  belongs_to :followed, class_name: User.name

  after_create :follow_activity
  after_destroy :unfollow_activity

  private
  def follow_activity
    create_activity Activity.activity_types[:follow]
  end

  def unfollow_activity
    create_activity Activity.activity_types[:unfollow]
  end

  def create_activity activity_type
    Activity.create user_id: self.follower_id, target_id: self.followed_id,
      action_type: activity_type
  end
end
