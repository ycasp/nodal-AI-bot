class MessagesController < ApplicationController

  SYSTEM_PROMPT = "You are a Sales Expert.\n\n
                  I am a business owner with some needs that is looking for some
                  advice in looking for products to match my needs.\n\n
                  Assist me by giving me the products you find useful to my case.\n\n
                  Answer in a format of a list with the product details in markdown format."
  PDF_MODEL = "claude-sonnet-4"

  def create
    @chat_current = current_user.chats.find(params[:chat_id])
    @chat_product = @chat_current.products

    build_message

    if @message.save

      ask_message_to_llm

      @message.chat.generate_title_from_first_message
      redirect_to chat_path(@chat_current)
      respond_to do |format|
        format.turbo_stream # renders `app/views/messages/create.turbo_stream.erb`
        format.html { redirect_to chat_path(@chat_current) }
      end

    else
      set_chat_sidebar_attributes
      render "chats/show", status: :unprocessable_entity
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("new_message", partial: "messages/form", locals: { chat: @chat_current, message: @message }) }
        format.html { render "chats/show", status: :unprocessable_entity }
      end
    end
  end


  private

  def build_message
    @message = Message.new(message_params)
    @message.chat = @chat_current
    @message.role = "user"
  end

  def message_params
    params.require(:message).permit(:content, :file)
  end

  def chat_product_context
    context = "Here are the products pre-selected I have interest on: \n\n"
    @chat_product.each do |product|
      context += "#{product.to_promt} \n\n"
    end
    return context
  end

  def ask_message_to_llm
    if @message.file.attached?
      process_file(@message.file) # send question w/ file to the appropriate model
    else
      send_question # send question to the model
    end
    @chat_current.messages.create(role: "assistant", content: @response.content)
  end

  def process_file(file)
    if file.content_type == "application/pdf"
      send_question(model: PDF_MODEL, with: { pdf: file.url })
    elsif file.image?
      send_question(model: "claude-sonnet-4", with: { image: @message.file.url })
    elsif file.audio?
      temp_file = Tempfile.new(["audio", File.extname(@message.file.filename.to_s)])

      URI.open(@message.file.url) do |remote_file|
        IO.copy_stream(remote_file, temp_file)
      end

    send_question(model: "gpt-4o-audio-preview", with: { audio: temp_file.path })
    temp_file.unlink
    end

  def send_question(model: "gpt-4.1-nano", with: {})
    @ruby_llm_chat = RubyLLM.chat(model: model)
    build_conversation_history
    @ruby_llm_chat.with_instructions(instructions)
    @response = @ruby_llm_chat.ask(@message.content, with: with)
  end

  def build_conversation_history
    @chat_current.messages.each {|message| @ruby_llm_chat.add_message({role: message.role, content: message.content}) }
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
