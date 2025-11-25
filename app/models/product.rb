class Product < ApplicationRecord
  has_one_attached :photo

  validates :name, presence: true
  validates :description, presence: true
  validates :category, presence: true


  has_many :chat_products, dependent: :destroy
  has_many :chats, through: :chat_products
end
