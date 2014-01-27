module Vendor
  class Receipt

    attr_reader :receipt_data, :params, :block

    def initialize(receipt_data, params, &block)
      @receipt_data = receipt_data
      @params = params
      @block = block

      check_receipt(receipt_data)
    end

    def check_receipt(receipt_data)
      password = @params.secret != "no_secret" ? @params.secret : nil

      CargoBay.sharedManager.verifyTransactionReceipt(receipt_data, password:password, success:lambda { |receipt|
        NSUserDefaults["#{@params.id}.receipt"] = receipt
        @block.call({success: true, object: receipt}.to_object) unless @block.blank?
      }, failure: lambda { |error|
        @block.call({success: false, error: error}.to_object) unless @block.blank?
      })
    end

  end
end