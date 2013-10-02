class Vendor
  
  attr_reader :product_id, :shared_secret, :product, :purchase, :exists

  # BB initializer
  def initialize(product_id = nil, shared_secret = nil, &result)
    # Set variables
    @product_id = product_id || "no_id"
    @shared_secret = shared_secret

    # Initialize product and purchase
    @product = ProductManager.new(@product_id, @shared_secret)
    @purchase = PurchaseManager.new(@product_id, @shared_secret)

    # Update product and set exists variable
    @product.update do |update_result|
      if update_result.success
        @exists = true
      else
        @exists = false
      end
      # result.call(update_result)
    end

    @product.update_receipt if is_subscription?
  end

# BB product methods

  def update(&result)
    @product.update { |product_result| 
      result.call(product_result) 
    }
  end

  def update_receipt(&result)
    @product.update_receipt { |product_result| result.call(product_result) }
  end

# BB purchase methods

  def purchase(&result)
    @purchase.purchase { |purchase_result| result.call(purchase_result)}
  end

  def restore(&result)
    @purchase.restore { |restore_result| result.call(restore_result)}
  end

# BB properties
  
  def exists?
    @exists || false
  end

  def price
    @product.price
  end

  def title
    @product.title
  end

  def description
    @product.description
  end

  def is_product_bought?
    @product.product_bought
  end

  def is_subscription?
    @product.is_subscription
  end

  def is_subscription_active?
    @product.subscription_active
  end

end