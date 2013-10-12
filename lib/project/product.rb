module Vendor
  class Product
    attr_reader :id_param, :secret_param, :subscription_param, :price_param, :title_param, :description_param, :result_param, :exists

    # Initialize product
    def initialize(options={}, &result)
      # Set variables
      @id_param = options[:id] || "no_id"
      @secret_param = options[:secret] || "no_secret"
      @subscription_param = options[:subscription] || false
      @price_param = options[:price] || "0.99"
      @title_param = options[:title] || "No Title"
      @description_param = options[:description] || "No Description."
      @result_param = result

      # Raise argument error if id is not included
      raise ArgumentError, "VENDOR WARNING: You forgot to write in your items id. You can't sell items without an id." if @id_param=="no_id"
      raise ArgumentError, "VENDOR WARNING: You're missing the shared secret." if @subscription_param && @secret_param=="no_secret"
      
      # Initialize product and purchase
      # @info = Vendor::Info.new(@id_param, @secret_param)
      # @buy = Vendor::Buy.new(@id_param, @secret_param)

      # Update product and set exists variable
      @info = Vendor::Info.new(@id_param, @secret_param) do |block|
        @exists = block.success
        @result_param.call(block) unless @result_param.nil?
      end

      # @product.update_receipt if is_subscription?
    end



    # Update product info and receipt

    def update_receipt(&result)
      @product.update_receipt { |product_result| result.call(product_result) }
    end



    # Purchase and restore product
    def purchase(&result)
      @purchase.purchase { |purchase_result| result.call(purchase_result)}
    end

    def restore(&result)
      @purchase.restore { |restore_result| result.call(restore_result)}
    end



    # Getting information on product
    def price
      @product.price
    end

    def title
      @product.title
    end

    def description
      @product.description
    end



    # Checking things on product
    def exists?
      @exists || false
    end

    def purchased?
      @product.product_bought
    end

    def subscription?
      @product.is_subscription
    end

    def subscribed?
      @product.subscription_active
    end

  end
end