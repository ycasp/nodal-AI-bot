class MessagesController < ApplicationController

  SYSTEM_PROMPT = "You are a Sales Expert.\n\nI am a business owner with some needs that is looking for some advice in looking for products to match my needs.\n\nAssist me by giving me the products you find useful to my case.\n\nAnswer in a format of a list with the product details."

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @chat_product = @chat.chat_product

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      ruby_llm_chat = RubyLLM.chat
      response = ruby_llm_chat.with_instructions(SYSTEM_PROMPT).ask(@message.content)
      Message.create(role: "assistant", content: response.content, chat: @chat)

      redirect_to chat_messages_path(@chat)
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
