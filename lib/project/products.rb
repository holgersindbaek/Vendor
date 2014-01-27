module Vendor
  class Products
    attr_reader :block, :products

    def [](key)
      return @products.select{ |p| p.params[:name]==key.to_s }.first
    end

    def initialize(products=[], &block)
      # Set up products array
      @products = []

      # Set up block
      @block = block

      # Set up blocks for giving a callback
      @blocks = []

      # Initialize buy block
      @buy = Vendor::Buy.new

      # Set up info for products
      products.each do |product|
        # Set default options
        default_options = {
          :id => "no_id",
          :secret => "no_secret",
          :subscription => false,
          :price => "0.99",
          :title => "No Title",
          :desc => "No Description."
        }
        options = default_options.merge(product)

        # Update product and set exists variable
        @products << Vendor::Product.new(options.to_object, @buy) do |block|
          @blocks << block
          @block.call(@blocks) unless @block.nil? || @blocks.count!=@products.count
        end
      end
    end
  end
end