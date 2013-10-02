class ProductManager

# Product Initializer

  def initialize(product_id, shared_secret)
    @product_id = product_id
    @shared_secret = shared_secret
  end
  
# Product methods

  def update(&result)
    # ap "ProductManager update"
    @result = result
    productsRequest = SKProductsRequest.alloc.initWithProductIdentifiers(NSSet.setWithObject(@product_id))
    productsRequest.delegate = self
    productsRequest.start
  end

  def update_receipt
    # ap "ProductManager update_receipt"
    # ap "update_receipt 1"
    receipt_data = App::Persistence["#{@product_id}.receipt_data"]
    # ap "update_receipt 2"
    @receipt = Receipt.new(receipt_data, @shared_secret) do |response|
      # ap "update_receipt succeeded: #{response.object}"
      # ap "update_receipt 3"
      App::Persistence["#{@product_id}.receipt"] = response.object if response.success
      # ap "update_receipt 4"
    end
  end

# Product properties  

  def price
    # ap "ProductManager price"
    price_locale = NSLocale.alloc.initWithLocaleIdentifier(App::Persistence["#{@product_id}.priceLocale"] || "en_US@currency=USD")
    price = App::Persistence["#{@product_id}.price"] || "0.99"

    formatter = NSNumberFormatter.alloc.init
    formatter.setFormatterBehavior(NSNumberFormatterBehavior10_4)
    formatter.setNumberStyle(NSNumberFormatterCurrencyStyle)
    formatter.setLocale(price_locale)

    formatter.stringFromNumber(price) 
  end

  def title
    # ap "ProductManager title"
    App::Persistence["#{@product_id}.localizedTitle"] || "Title is not ready"
  end

  def description
    # ap "ProductManager description"
    App::Persistence["#{@product_id}.localizedDescription"] || "Description is not ready"
  end

  def product_bought
    App::Persistence["#{@product_id}.receipt"].present?
  end

  # TODO - Check if purchase is subscription
  def is_subscription
    # ap "ProductManager is_subscription"
    return false if !product_bought
    receipt_object = BW::JSON.parse(App::Persistence["#{@product_id}.receipt"]).to_object
    receipt_object.receipt['expires_date'].present?
  end

  def subscription_active
    # ap "ProductManager subscription_active"
    return false if !product_bought
    receipt_object = BW::JSON.parse(App::Persistence["#{@product_id}.receipt"]).to_object
    return false if receipt_object.blank? || receipt_object.status!=0

    decoder = CocoaSecurityDecoder.new
    latest_receipt_data = decoder.base64(receipt_object.latest_receipt)
    latest_receipt_plist = NSPropertyListSerialization.propertyListWithData(latest_receipt_data, options:NSPropertyListImmutable, format:nil, error:nil)

    purchase_info_data = decoder.base64(latest_receipt_plist.objectForKey("purchase-info"))
    purchase_info_plist = NSPropertyListSerialization.propertyListWithData(purchase_info_data, options:NSPropertyListImmutable, format:nil, error:nil)

    expires_date = purchase_info_plist.objectForKey("expires-date")
    # ap "expires_date: #{expires_date}"
    expires_calc = expires_date.to_i/1000

    return expires_calc > NSDate.date.timeIntervalSince1970
  end

# Delegate methods

  def productsRequest(request, didReceiveResponse:response) 
    product_exists = response.invalidProductIdentifiers.count==0

    @result.call({success: product_exists, response: response}.to_object)

    # Save needed product info
    if product_exists
      product = response.products.first
      # ap "ProductManager 3"
      App::Persistence["#{@product_id}.priceLocale"] = product.priceLocale.localeIdentifier
      # ap "ProductManager 4"
      App::Persistence["#{@product_id}.price"] = product.price
      # ap "ProductManager 5"
      App::Persistence["#{@product_id}.localizedTitle"] = product.localizedTitle
      # ap "ProductManager 6"
      App::Persistence["#{@product_id}.localizedDescription"] = product.localizedDescription
      # ap "ProductManager 7"
    end
  end
 
  def request(request, didFailWithError:error)
    @result.call({success: false, error: error}.to_object)
  end

end