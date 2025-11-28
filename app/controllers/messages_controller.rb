require "open-uri"

class MessagesController < ApplicationController

  SYSTEM_PROMPT = <<~PROMPT
    You are a Sales Expert.

    I am a business owner and selected some products you have in your store.
    But I have some questions about the product.

    Assist me in answering my question and fullfilling the task.
    Help me out with speficing the product details for my need.

    If there is no matching product selected in the prompt,
    please access the product table of our database / shop and help me out.

    Answer in a format of a list with the product details in markdown format.
  PROMPT

  PDF_MODEL = "claude-sonnet-4"
  IMG_MODEL = "claude-sonnet-4"
  AUDIO_MODEL = "gemini-2.0-flash"

  def create
    @chat_current = current_user.chats.find(params[:chat_id])
    @chat_product = @chat_current.products

    build_message

    if @message.save

      ask_message_to_llm

      @message.chat.generate_title_from_first_message
      respond_to do |format|
        format.turbo_stream # renders `app/views/messages/create.turbo_stream.erb`
        format.html { redirect_to chat_path(@chat_current) }
      end

    else
      set_chat_sidebar_attributes
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("new_message", partial: "messages/form", locals: { chat_current: @chat_current, message: @message }) }
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
      context += "#{product.to_prompt} \n\n"
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
      send_question(model: IMG_MODEL, with: { image: @message.file.url })
    elsif file.audio?
      temp_file = Tempfile.new(["audio", File.extname(@message.file.filename.to_s)])

      URI.open(@message.file.url) do |remote_file|
        IO.copy_stream(remote_file, temp_file)
      end

      send_question(model: AUDIO_MODEL, with: { audio: temp_file.path })
      temp_file.unlink
    end
  end

  def send_question(model: "gpt-4.1-nano", with: {})
    @ruby_llm_chat = RubyLLM.chat(model: model)
    build_conversation_history
    @ruby_llm_chat.with_instructions(instructions)
    proudcts_access = ProductsAccessTool.new
    @ruby_llm_chat.with_tool(proudcts_access)
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
