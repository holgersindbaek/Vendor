module Vendor
  class Info
    attr_accessor :id, :secret, :block

    # Product Initializer
    def initialize(id, secret, &block)
      @id = id
      @secret = secret
      @block = block

      productsRequest = SKProductsRequest.alloc.initWithProductIdentifiers(NSSet.setWithObject(@id))
      productsRequest.delegate = self
      productsRequest.start
    end
      
    # Product methods
    def update_receipt
      # ap "ProductManager update_receipt"
      # ap "update_receipt 1"
      receipt_data = App::Persistence["#{@id}.receipt_data"]
      # ap "update_receipt 2"
      @receipt = Receipt.new(receipt_data, @secret) do |response|
        # ap "update_receipt succeeded: #{response.object}"
        # ap "update_receipt 3"
        App::Persistence["#{@id}.receipt"] = response.object if response.success
        # ap "update_receipt 4"
      end
    end

    # Product properties  

    def price
      # ap "ProductManager price"
      price_locale = NSLocale.alloc.initWithLocaleIdentifier(App::Persistence["#{@id}.priceLocale"] || "en_US@currency=USD")
      price = App::Persistence["#{@id}.price"] || "0.99"

      formatter = NSNumberFormatter.alloc.init
      formatter.setFormatterBehavior(NSNumberFormatterBehavior10_4)
      formatter.setNumberStyle(NSNumberFormatterCurrencyStyle)
      formatter.setLocale(price_locale)

      formatter.stringFromNumber(price) 
    end

    def title
      # ap "ProductManager title"
      App::Persistence["#{@id}.localizedTitle"] || "Title is not ready"
    end

    def description
      # ap "ProductManager description"
      App::Persistence["#{@id}.localizedDescription"] || "Description is not ready"
    end

    def product_bought
      App::Persistence["#{@id}.receipt"].present?
    end

    # TODO - Check if purchase is subscription
    def is_subscription
      # ap "ProductManager is_subscription"
      return false if !product_bought
      receipt_object = BW::JSON.parse(App::Persistence["#{@id}.receipt"]).to_object
      receipt_object.receipt['expires_date'].present?
    end

    def subscription_active
      # ap "ProductManager subscription_active"
      return false if !product_bought
      receipt_object = BW::JSON.parse(App::Persistence["#{@id}.receipt"]).to_object
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
      # ap "didReceiveResponse: #{response}"
      # ap "response.invalidProductIdentifiers.count: #{response.invalidProductIdentifiers.count}"
      exists = response.invalidProductIdentifiers.count==0

      # ap "exists: #{exists}"

      @block.call({success: exists, response: response}.to_object)

      # Save needed product info
      # if exists
      #   product = response.products.first
      #   App::Persistence["#{@id}.priceLocale"] = product.priceLocale.localeIdentifier
      #   App::Persistence["#{@id}.price"] = product.price
      #   App::Persistence["#{@id}.localizedTitle"] = product.localizedTitle
      #   App::Persistence["#{@id}.localizedDescription"] = product.localizedDescription
      # end
    end
   
    def request(request, didFailWithError:error)
      @block.call({success: false, error: error}.to_object)
    end

  end
end