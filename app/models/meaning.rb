class Meaning < ApplicationRecord
  belongs_to :word
  has_many :results
  has_many :lessons, through: :results

  validates :content, presence: true, length: {maximum: 50}

  scope :remembered_words, ->result_ids do
    joins(:results).where "results.id IN (:result_ids)
      AND meanings.is_correct = :is_correct",
      result_ids: result_ids, is_correct: true
  end
end
