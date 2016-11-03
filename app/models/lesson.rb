class Lesson < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :results, dependent: :destroy
  has_many :words, through: :results
  has_many :meanings, through: :results

  delegate :name, to: :category

  validates :user, presence: true
  validates :category, presence: true

  before_create :build_results
  after_create :start_lesson_activity
  after_update :finish_lesson_activity

  accepts_nested_attributes_for :results,
    reject_if: proc {|attributes| attributes[:meaning_id].blank?},
    allow_destroy: true

  scope :result_ids, ->{joins(:results).pluck "results.id"}

  def set_scores scores
    self.update_attributes scores: scores
  end

  def first_update?
    self.is_finished?
  end

  private
  def build_results
    self.category.words.random.limit(Settings.word_per_lesson).each do |word|
      self.results.build word_id: word.id
    end
  end

  def start_lesson_activity
    create_activity Activity.activity_types[:start_lesson]
  end

  def finish_lesson_activity
    create_activity Activity.activity_types[:finish_lesson]
  end

  def create_activity activity_type
    Activity.create user_id: self.user_id, target_id: self.id,
      action_type: activity_type
  end
end
