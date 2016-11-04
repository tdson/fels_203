
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

  scope :only_correct_meaning, ->do
    joins(:meanings).where "meanings.is_correct = :is_correct", is_correct: true
  end
  scope :search_word_or_category, ->(q) do
    joins(:category)
      .where "words.content LIKE :query OR categories.name LIKE :query",
        query: "%#{q}%" if q.present?
  end
  scope :learned, ->user_id do
    where "words.id IN (SELECT word_id FROM results WHERE lesson_id IN
      (SELECT id FROM lessons WHERE user_id = ?))", user_id
  end
  scope :not_learned, ->user_id do
    where "words.id NOT IN (SELECT word_id FROM results WHERE lesson_id IN
      (SELECT id FROM lessons WHERE user_id = ?))", user_id
  end
  scope :remembered, ->user_id do
    where "words.id IN (SELECT results.word_id FROM results INNER JOIN meanings
      ON results.meaning_id = meanings.id
        WHERE lesson_id IN (SELECT id FROM lessons WHERE user_id = ?)
          AND meanings.is_correct = ?)",user_id, true
  end

  class << self
    def to_csv
      attributes = [I18n.t("words.csv.word"), I18n.t("words.csv.meaning")]
      CSV.generate(headers: true) do |csv|
        csv << attributes
        all.each do |word|
          csv << [word.content, word.meanings.first.content]
        end
      end
    end
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
