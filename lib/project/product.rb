module Vendor
  class Product
    attr_reader :params, :block, :exists, :info, :buy

    def initialize(options={}, &block)
      # Set default options
      default_options = {
        :id => "no_id",
        :secret => "no_secret",
        :subscription => false,
        :price => "0.99",
        :title => "No Title",
        :desc => "No Description."
      }

      # Set global params and block
      options = default_options.merge(options)
      @params = options.to_object
      @block = block

      # Raise argument error if id is not included
      raise ArgumentError, "VENDOR WARNING: You forgot to write in your item id. You can't sell item without an id." if @params.id == "no_id"
      raise ArgumentError, "VENDOR WARNING: You're missing your subscriptions shared secret. Subscriptions must have a shared secret." if @params.subscription && @params.secret == "no_secret"

      # Update product and set exists variable
      @info = Vendor::Info.new(@params) do |block|
        @exists = block.success
        @block.call(block) unless @block.nil?
      end

      # Initialize purchase
      @buy = Vendor::Buy.new(@params)
    end



    # PURCHASE METHODS
    def purchase(&block)
      @buy.purchase { |result| block.call(result)}
    end

    def restore(&block)
      @buy.restore { |result| block.call(result)}
    end



    # INFO METHODS
    def price
      @info.price
    end

    def title
      @info.title
    end

    def description
      @info.description
    end

    def exists?
      @exists || false
    end

    def bought?
      @info.bought?
    end

    def subscription?
      @info.subscription?
    end

    def subscribed?
      @info.subscribed?
    end

  end
end