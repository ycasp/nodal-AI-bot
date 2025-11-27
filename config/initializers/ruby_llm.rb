RubyLLM.configure do |config|
  config.openai_api_key = ENV["OPEN_AI_KEY"]
  config.openai_api_base = "https://models.inference.ai.azure.com"
end
