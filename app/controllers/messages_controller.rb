class MessagesController < ApplicationController

  SYSTEM_PROMPT = "You are a Sales Expert.\n\n
                  I am a business owner with some needs that is looking for some
                  advice in looking for products to match my needs.\n\n
                  Assist me by giving me the products you find useful to my case.\n\n
                  Answer in a format of a list with the product details in markdown format."

  def create
    @chat_current = current_user.chats.find(params[:chat_id])
    @chat_product = @chat_current.products

    build_message

    if @message.save
      ask_message_to_llm
      redirect_to chat_path(@chat_current)
    else
      set_chat_sidebar_attributes
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def build_message
    @message = Message.new(message_params)
    @message.chat = @chat_current
    @message.role = "user"
  end

  def message_params
    params.require(:message).permit(:content)
  end

  def chat_product_context
    context = "Here are the products pre-selected I have interest on: \n\n"
    @chat_product.each do |product|
      context += "#{product.to_promt} \n\n"
    end
    return context
  end

  def ask_message_to_llm
    @ruby_llm_chat = RubyLLM.chat
    build_conversation_history
    response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content)
    Message.create(role: "assistant", content: response.content, chat: @chat_current)
    @message.chat.generate_title_from_first_message
  end

  def build_conversation_history
    @chat_current.messages.each {|message| @ruby_llm_chat.add_message(message) }
  end

  def instructions
    [SYSTEM_PROMPT, chat_product_context].compact.join("\n\n")
  end

  def set_chat_sidebar_attributes
    @chat_new = Chat.new(title: "Untitled")
    @products = Product.all
    @chats = current_user.chats.all
  end
end
