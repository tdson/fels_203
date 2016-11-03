class Word < ApplicationRecord
  belongs_to :category
  has_many :meanings, dependent: :destroy
  has_many :results, dependent: :destroy
  has_many :lessons, through: :results

  accepts_nested_attributes_for :meanings, allow_destroy: true

  scope :random, ->{order "RANDOM()"}
  scope :order_by_alphabetical_content, ->{order :content}
  scope :search_content, ->content do
    where "content LIKE ?", "%#{content}%" if content.present?
  end
  scope :of_category, ->category_id do
    where category_id: category_id if category_id.present?
  end
end
