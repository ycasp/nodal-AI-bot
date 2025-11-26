class Message < ApplicationRecord
  belongs_to :chat
  before_validation :strip_content

  validates :content, presence: true

  MAX_USER_MESSAGES = 10

  validate :user_message_limit, if: -> { role == "user" }

  private

  def user_message_limit
    if chat.messages.where(role: "user").count >= MAX_USER_MESSAGES
      errors.add(:content, "You can only send #{MAX_USER_MESSAGES} messages per chat.")
    end
  end

  def strip_content
    self.content = content.strip if content.present?
  end
end
