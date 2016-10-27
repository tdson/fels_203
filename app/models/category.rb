class Category < ApplicationRecord
  has_many :words, dependent: :destroy
  has_many :lessons, dependent: :destroy

  scope :order_by_name, ->{order :name}
  scope :newest, ->{order created_at: :desc}
  scope :search_name, ->name do
    where "name LIKE ?", "%#{name}%" if name.present?
  end
end
