module Vendor
  class Buy
    attr_accessor :params, :block, :request_operation_queue

    def initialize
      SKPaymentQueue.defaultQueue.addTransactionObserver(self)
    end

    def close
      SKPaymentQueue.defaultQueue.removeTransactionObserver(self)
    end



    # PUBLIC METHODS
    def purchase(params, &block)
      @params = params
      @block = block
      SKPaymentQueue.defaultQueue.addPayment(SKPayment.paymentWithProductIdentifier(@params.id))
    end

    def restore(params, &block)
      @params = params
      @block = block
      SKPaymentQueue.defaultQueue.restoreCompletedTransactions
    end



    # DELEGATE METHODS
    def finishTransaction(transaction, success:success)
      SKPaymentQueue.defaultQueue.finishTransaction(transaction)
      return if @params.nil?
      password = @params.secret=="no_secret" ? nil : @params.secret

      if success
        # Verify transaction receipt
        Vendor::Receipt.new(transaction.transactionReceipt, @params) do |block|
          valid_receipt = block[:success] && block[:object][:status]==0
          @block.call({success: valid_receipt, transaction: transaction}.to_object) unless @block.blank?
        end
      else
        @block.call({success: success, transaction: transaction}.to_object) unless @block.blank?
      end
    end

    def paymentQueue(queue, updatedTransactions:transactions)
      transactions.each do |transaction|
        case transaction.transactionState
          when 1 #SKPaymentTransactionStatePurchased
            completeTransaction(transaction)
          when 2 #SKPaymentTransactionStateFailed
            failedTransaction(transaction)
          when 3 #SKPaymentTransactionStateRestored
            restoreTransaction(transaction)
          else 
        end
      end
    end

    def completeTransaction(transaction)
      finishTransaction(transaction, success:true)
    end

    def restoreTransaction(transaction)
      finishTransaction(transaction, success:true)
    end

    def failedTransaction(transaction)
      finishTransaction(transaction, success:false)
    end

  end
end