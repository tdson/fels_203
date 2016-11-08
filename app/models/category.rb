class Category < ApplicationRecord
  has_many :words, dependent: :destroy
  has_many :lessons, dependent: :destroy

  validates :name, presence: true, length: {maximum: 40, minimum: 3}

  mount_uploader :image, ImageUploader

  scope :order_by_name, ->{order :name}
  scope :newest, ->{order created_at: :desc}
  scope :search_name, ->name do
    where "name LIKE ?", "%#{name}%" if name.present?
  end
end
