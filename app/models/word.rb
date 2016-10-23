class Word < ApplicationRecord
  belongs_to :category
  has_many :meanings, dependent: :destroy
  has_many :results
  has_many :lessons, through: :results

  accepts_nested_attributes_for :meanings, allow_destroy: true

  scope :random, ->{order "RANDOM()"}
end
