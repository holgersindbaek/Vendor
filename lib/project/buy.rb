module Vendor
  class Buy
    attr_accessor :params, :block, :request_operation_queue

    def initialize(params)
      @params = params
      SKPaymentQueue.defaultQueue.addTransactionObserver(self)
    end

    def close
      SKPaymentQueue.defaultQueue.removeTransactionObserver(self)
    end



    # PUBLIC METHODS
    def purchase(&block)
      @block = block
      SKPaymentQueue.defaultQueue.addPayment(SKPayment.paymentWithProductIdentifier(@params.id))
    end

    def restore(&block)
      @block = block
      SKPaymentQueue.defaultQueue.restoreCompletedTransactions
    end



    # DELEGATE METHODS
    def finishTransaction(transaction, success:success)
      SKPaymentQueue.defaultQueue.finishTransaction(transaction)
      SKPaymentQueue.defaultQueue.removeTransactionObserver(self)
      
      if success
        Vendor::Receipt.new(transaction.transactionReceipt, @params) do |block|
          result_object = BW::JSON.parse(block.object).to_object
          valid_receipt = block.success && result_object.status.to_i == 0

          @block.call({success: valid_receipt, transaction: transaction}.to_object) unless @block.blank?
        end
      else
        @block.call({success: success, transaction: transaction}.to_object) unless @block.blank?
      end
    end

    def paymentQueue(queue, updatedTransactions:transactions)
      transactions.each do |transaction|
        case transaction.transactionState
          when SKPaymentTransactionStatePurchased
            completeTransaction(transaction)
          when SKPaymentTransactionStateFailed
            failedTransaction(transaction)
          when SKPaymentTransactionStateRestored
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