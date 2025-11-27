class Message < ApplicationRecord
  belongs_to :chat
  before_validation :strip_content

  validates :content, presence: true
  has_one_attached :file

  MAX_USER_MESSAGES = 10
  MAX_FILE_SIZE_MB = 10

  validate :file_size_limit

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

  def file_size_limit
    if file.attached? && file.byte_size > MAX_FILE_SIZE_MB.megabytes
      errors.add(:file, "size must be less than #{MAX_FILE_SIZE_MB}MB")
  end
end
