class Receipt

  attr_reader :result, :received_data, :request_operation_queue

# Receipt Initializer

  def initialize(receipt_data, shared_secret, &result)
    @result = result
    @shared_secret = shared_secret
    @request_operation_queue = NSOperationQueue.alloc.init

    check_receipt(receipt_data)
  end

# Receipt methods

  def check_receipt(receipt_data)
    # ap "check_receipt(receipt_data): #{receipt_data}"
    encoder = CocoaSecurityEncoder.new
    json_data = {"receipt-data" => encoder.base64(receipt_data), "password" => @shared_secret}
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
      @result.call({success: true, object: response_object}.to_object)
    }, failure: lambda {|operation, error|
      @result.call({success: false, error: error}.to_object)
    })

    @request_operation_queue.addOperation(request_operation)
  end

end