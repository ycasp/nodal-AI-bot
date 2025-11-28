class ProductsAccessTool < RubyLLM::Tool
  description "Access to the all Products stored in the Database/Shop."

  def execute
    products = Product.all
    return products.map { |product| product.to_prompt }
  end
end
