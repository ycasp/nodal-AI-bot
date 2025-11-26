class ChatsController < ApplicationController

  def index
    @chats = current_user.chats.all
    @chat = Chat.new(title: Chat::DEFAULT_TITLE)
    @products = Product.all
  end

  def show
    # for the side bar
    @chats = current_user.chats.all
    @chat_new = Chat.new(title: Chat::DEFAULT_TITLE)
    @products = Product.all

    # for the chat window
    @chat_current = current_user.chats.find(params[:id])
    @message = Message.new
  end

  def create
    @chat = Chat.new(title: Chat::DEFAULT_TITLE)
    @chat.user = current_user
    if @chat.save
      unless chat_params.empty?
        product_ids = chat_params[:product_ids].compact_blank
        product_ids.each do |product_id|
          @chat_products=ChatProduct.create(chat_id: @chat.id, product_id: product_id.to_i)
        end
      end
      redirect_to chat_path(@chat)
    else
      render "chats/index"
    end
  end

  def destroy
    @chat = current_user.chats.find(params[:id])
    @chat.destroy
    redirect_to chats_path, notice: "Chat deleted successfully."
  end


  private

  def chat_params
    if params.key?(:chat)
      params.require(:chat).permit(product_ids: [])
    else
      return {}
    end
  end
end
