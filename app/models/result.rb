class Result < ApplicationRecord
  belongs_to :lesson
  belongs_to :word
  belongs_to :meaning, optional: true

  delegate :user_id, to: :lesson

  scope :correct_meanings, ->do
    joins(:meaning)
      .where "meanings.is_correct = ?", true
  end
end
