class ChatsController < ApplicationController
  before_action :set_chat_sidebar_attributes, only: [:index, :show]

  def index
  end

  def show
    # for the chat window
    @chat_current = current_user.chats.find(params[:id])
    @message = Message.new
  end

  def create
    @chat = Chat.new(title: Chat::DEFAULT_TITLE)
    @chat.user = current_user
    if @chat.save
      add_products_to_chat
      redirect_to chat_path(@chat)
    else
      set_chat_sidebar_attributes
      render "chats/index", stauts: :unprocessable_entitiy
    end
  end

  def destroy
    @chat = current_user.chats.find(params[:id])
    @chat.destroy
    redirect_to chats_path, notice: "Chat deleted successfully."
  end


  private

  def chat_params
    return params.key?(:chat) ? params.require(:chat).permit(product_ids: []) : {}
  end

  def add_products_to_chat
    unless chat_params.empty?
      product_ids = chat_params[:product_ids].compact_blank
      product_ids.each do |product_id|
        @chat_products=ChatProduct.create(chat_id: @chat.id, product_id: product_id.to_i)
      end
    end
  end

  def set_chat_sidebar_attributes
    @chats = current_user.chats.all
    @chat_new = Chat.new(title: Chat::DEFAULT_TITLE)
    @products = Product.all
  end
end
