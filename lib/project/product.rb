module Vendor
  class Product
    attr_reader :params, :result_param, :exists, :info

    # Initialize product
    def initialize(options={}, &result)
      # Set params
      @params = Vendor::Params.new
      @params.id = options[:id] || "no_id"
      @params.secret = options[:secret] || "no_secret"
      @params.subscription = options[:subscription] || false
      @params.price = options[:price] || "0.99"
      @params.title = options[:title] || "No Title"
      @params.description = options[:description] || "No Description."
      @result_param = result

      # Raise argument error if id is not included
      raise ArgumentError, "VENDOR WARNING: You forgot to write in your item id. You can't sell item without an id." if @params.id=="no_id"
      raise ArgumentError, "VENDOR WARNING: You're missing your subscriptions shared secret. Subscriptions must have a shared secret." if @params.subscription && @params.secret=="no_secret"

      # Initialize product and purchase
      # @info = Vendor::Info.new(@id_param, @secret_param)
      # @buy = Vendor::Buy.new(@id_param, @secret_param)

      # Update product and set exists variable
      @info = Vendor::Info.new(@params) do |block|
        @exists = block.success
        @result_param.call(block) unless @result_param.nil?
      end
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

    def bought?
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