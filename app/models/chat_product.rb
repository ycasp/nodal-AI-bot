class ChatProduct < ApplicationRecord
  belongs_to :product
  belongs_to :chat
end
