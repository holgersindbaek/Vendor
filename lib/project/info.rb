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
      update_receipt if bought? && subscription?
    end


    # PUBLIC METHODS
    def update_receipt
      receipt_data = NSUserDefaults["#{@params.id}.receipt_data"]
      @receipt = Receipt.new(receipt_data, @secret) do |response|
        NSUserDefaults["#{@params.id}.receipt"] = response.object if response.success
      end
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
      NSUserDefaults["#{@params.id}.localizedDescription"] || @params.description
    end

    def bought?
      NSUserDefaults["#{@params.id}.receipt"].present?
    end

    def subscription?
      return @params.subscription
    end

    def subscribed?
      return false if !subscription?
      receipt_object = BW::JSON.parse(App::Persistence["#{@params.id}.receipt"]).to_object
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


    # DELEGATE METHODS
    def productsRequest(request, didReceiveResponse:response) 
      ap ""
      ap response
      ap response.invalidProductIdentifiers
      ap response.products
      exists = response.invalidProductIdentifiers.count==0

      @block.call({success: exists, response: response}.to_object)

      # Save needed product info
      if exists
        product = response.products.first
        App::Persistence["#{@params.id}.price"] = product.price
        App::Persistence["#{@params.id}.localizedTitle"] = product.localizedTitle
        App::Persistence["#{@params.id}.localizedDescription"] = product.localizedDescription
      end
    end
   
    def request(request, didFailWithError:error)
      NSLog "error: #{error.userInfo}"
      @block.call({success: false, error: error}.to_object)
    end

  end
end