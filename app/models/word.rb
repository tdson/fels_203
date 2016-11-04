class Word < ApplicationRecord
  belongs_to :category
  has_many :meanings, dependent: :destroy, inverse_of: :word
  has_many :results, dependent: :destroy
  has_many :lessons, through: :results

  accepts_nested_attributes_for :meanings, allow_destroy: true

  validates :content, presence: true, length: {maximum: 50}, uniqueness: true
  validate :number_of_meanings

  scope :random, ->{order "RANDOM()"}
  scope :order_by_alphabetical_content, ->{order :content}
  scope :search_content, ->content do
    where "content LIKE ?", "%#{content}%" if content.present?
  end
  scope :of_category, ->category_id do
    where category_id: category_id if category_id.present?
  end

  private
  def number_of_meanings
    if meanings.length > Settings.admin.max_meanings
      errors.add :word, I18n.t("validates.words.too_many_options")
    elsif meanings.length < Settings.admin.min_meanings
      errors.add :word, I18n.t("validates.words.too_less_options")
    end
    size_of_correct_meaning = meanings.select{|answer| answer.is_correct?}.size
    unless size_of_correct_meaning == Settings.admin.allow_correct_meaning
      errors.add :word, I18n.t("validates.words.too_many_correct_options")
    end
  end
end
