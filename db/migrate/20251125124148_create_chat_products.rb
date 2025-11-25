class CreateChatProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :chat_products do |t|
      t.references :product, null: false, foreign_key: true
      t.references :chat, null: false, foreign_key: true

      t.timestamps
    end
  end
end
