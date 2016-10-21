class Meaning < ApplicationRecord
  belongs_to :word
  has_many :results
  has_many :lessons, through: :results
end
