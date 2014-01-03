module Vendor
  class Receipt

    attr_reader :receipt_data, :params, :request_operation_queue, :block

    def initialize(receipt_data, params, &block)
      @receipt_data = receipt_data
      @params = params
      @block = block
      @request_operation_queue = NSOperationQueue.alloc.init

      check_receipt(receipt_data)
    end

    def check_receipt(receipt_data)
      encoder = CocoaSecurityEncoder.new
      json_data = {"receipt-data" => encoder.base64(receipt_data)}
      json_data[:password] = @params.secret if @params.secret != "no_secret"
      server = App.development? ? "sandbox" : "buy"
      base_url = NSURL.URLWithString("https://#{server}.itunes.apple.com")

      # TODO - Could look nicer. Dunno if AFMotion could be used instead.
      client = AFHTTPClient.alloc.initWithBaseURL(base_url)
      client.setDefaultHeader("Accept", value:"application/json")
      client.registerHTTPOperationClass(AFJSONRequestOperation.class)
      client.setParameterEncoding(AFJSONParameterEncoding)
      AFJSONRequestOperation.addAcceptableContentTypes(NSSet.setWithObject("text/plain"))

      request = client.requestWithMethod("POST", path:"verifyReceipt", parameters:json_data)
      request_operation = client.HTTPRequestOperationWithRequest(request, success: lambda { |operation, response_object|
        NSUserDefaults["#{@params.id}.receipt_data"] = receipt_data
        NSUserDefaults["#{@params.id}.receipt"] = response_object
        @block.call({success: true, object: response_object}.to_object) unless @block.blank?
      }, failure: lambda {|operation, error|
        @block.call({success: false, error: error}.to_object) unless @block.blank?
      })

      @request_operation_queue.addOperation(request_operation)
    end

  end
end