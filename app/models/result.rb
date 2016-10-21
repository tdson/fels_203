class Result < ApplicationRecord
  belongs_to :lesson
  belongs_to :word
  belongs_to :meaning

  delegate :user_id, to: :lesson
end
