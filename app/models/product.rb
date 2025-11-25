class Product < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :category, presence: true

  has_many :chats, dependent: :destroy
end
