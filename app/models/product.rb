class Product < ApplicationRecord
  has_one_attached :photo

  validates :name, presence: true
  validates :description, presence: true
  validates :category, presence: true


  has_many :chat_products, dependent: :destroy
  has_many :chats, through: :chat_products

  def to_promt
    return "Product Name: #{name}, Product category: #{category}, \n
            Product Description: #{description} \n
            Minimum Quanitity to order: #{minimum_qty} \n
            Price per unit: #{price_unit}, Price per kilogram: #{price_kg} \n
            Country of origin: #{country_of_origin} \n
            Product expires in #{days_until_expired}"
  end
end
