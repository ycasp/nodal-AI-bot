class ChatsController < ApplicationController

  def index
    @chats = Chat.all
    # @chat = Chat.new(title: "Untitled")
    @products = Product.all
    @chat_prod_relation = ChatProduct.new
  end

  def create
    raise
    @chat = Chat.new(title: "Untitled")
    @chat.user = current_user

    product_ids = chat_params[:product_ids]



    if @chat.save
      redirect_to chat_path(@chat)
    else
      render "products/show"
    end
  end



  private

  def chat_params
    params.require(:chat).permit(products_ids: [])
  end
end
