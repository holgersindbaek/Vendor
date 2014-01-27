module Vendor
  class Info
    attr_accessor :params, :block

    def initialize(params, &block)
      @params = params
      @block = block

      # Start product request
      productsRequest = SKProductsRequest.alloc.initWithProductIdentifiers(NSSet.setWithObject(@params.id))
      productsRequest.delegate = self
      productsRequest.start

      # Update receipt if bought and subscription
      receipt = NSUserDefaults["#{@params.id}.receipt"]
      decoder = CocoaSecurityDecoder.new
      latest_receipt_data = decoder.base64(receipt[:latest_receipt])
      Vendor::Receipt.new(latest_receipt_data, @params) if bought? && subscription?
    end



    # INFO METHODS
    def price
      price = NSUserDefaults["#{@params.id}.price"] || @params.price
      price.to_f.string_with_style(NSNumberFormatterCurrencyStyle)
    end

    def title
      NSUserDefaults["#{@params.id}.localizedTitle"] || @params.title
    end

    def description
      NSUserDefaults["#{@params.id}.localizedDescription"] || @params.desc
    end

    def bought?
      NSUserDefaults["#{@params.id}.receipt"] != nil
    end

    def subscription?
      @params.subscription
    end

    def subscribed?
      # Return false if product is not a subscription or not bought
      return false if !subscription? || !bought?
      receipt = NSUserDefaults["#{@params.id}.receipt"]
      return false if receipt[:status].to_i!=0

      # Get the latest receipt
      receipt = NSUserDefaults["#{@params.id}.receipt"]
      decoder = CocoaSecurityDecoder.new
      latest_receipt_data = decoder.base64(receipt[:latest_receipt])
      latest_receipt_plist = NSPropertyListSerialization.propertyListWithData(latest_receipt_data, options:NSPropertyListImmutable, format:nil, error:nil)

      # Get the time for the latest receipt
      purchase_info_data = decoder.base64(latest_receipt_plist.objectForKey("purchase-info"))
      purchase_info_plist = NSPropertyListSerialization.propertyListWithData(purchase_info_data, options:NSPropertyListImmutable, format:nil, error:nil)

      # Manipulate the time for the latest receipt
      expires_date = purchase_info_plist.objectForKey("expires-date")
      expires_calc = expires_date.to_i/1000

      # Check if the latest receipt is too old
      return expires_calc > NSDate.date.timeIntervalSince1970
    end



    # DELEGATE METHODS
    def productsRequest(request, didReceiveResponse:response) 
      exists = response.invalidProductIdentifiers.count==0

      # Save needed product info
      if exists
        product = response.products.first
        NSUserDefaults["#{@params.id}.price"] = product.price
        NSUserDefaults["#{@params.id}.localizedTitle"] = product.localizedTitle
        NSUserDefaults["#{@params.id}.localizedDescription"] = product.localizedDescription
      end

      @block.call({success: exists, response: response}.to_object)
    end
   
    def request(request, didFailWithError:error)
      @block.call({success: false, error: error}.to_object)
    end
  end
end