class Chat < ApplicationRecord
  belongs_to :user

  has_many :chat_products, dependent: :destroy
  has_many :products, through: :chat_products
end
