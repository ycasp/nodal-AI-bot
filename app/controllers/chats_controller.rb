class ChatsController < ApplicationController

  def index
    @chats = current_user.chats.all
    @chat = Chat.new(title: "Untitled")
    @products = Product.all
  end

  def show
    # for the side bar
    @chats = current_user.chats.all
    @chat_new = Chat.new(title: "Untitled")
    @products = Product.all

    # for the chat window
    @chat_current = current_user.chats.find(params[:id])
    @message = Message.new
  end

  def create

    @chat = Chat.new(title: "Untitled")
    @chat.user = current_user
    if @chat.save
      product_ids = chat_params[:product_ids].compact_blank
      product_ids.each do |product_id|
        @chat_products=ChatProduct.create(chat_id: @chat.id, product_id: product_id.to_i)
      end
      redirect_to chats_path
    else
      render "chats/index"
    end
  end



  private

  def chat_params
    params.require(:chat).permit(product_ids:[])
  end
end
