class Chat < ApplicationRecord
  belongs_to :user

  has_many :products, through: :chat_products
  has_many :chat_products, dependent: :destroy
end
