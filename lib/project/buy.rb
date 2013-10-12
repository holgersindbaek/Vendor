module Vendor
  class Buy

  # Purchase Initializer

    def initialize(id, secret)
      # ap "PurchaseManager initialize"
      # ap "shared_secret: #{shared_secret}"
      @product_id = id
      @shared_secret = secret
      @number = 0
      SKPaymentQueue.defaultQueue.addTransactionObserver(self)
    end

  # Purchase methods

    def purchase(&result)
      # ap "PurchaseManager purchase"
      @result = result
      SKPaymentQueue.defaultQueue.addPayment(SKPayment.paymentWithProductIdentifier(@product_id))
    end

    def restore(&result)
      # ap "PurchaseManager restore"
      @result = result
      SKPaymentQueue.defaultQueue.restoreCompletedTransactions
    end

  # Delegate methods

    def paymentQueueRestoreCompletedTransactionsFinished(queue)
      # ap "PurchaseManager paymentQueueRestoreCompletedTransactionsFinished"
    end

    def paymentQueue(queue, restoreCompletedTransactionsFailedWithError:error)
      # ap "PurchaseManager paymentQueue restoreCompletedTransactionsFailedWithError"
    end

    def finishTransaction(transaction, wasSuccessful:wasSuccessful)
      # ap "PurchaseManager finishTransaction"
      SKPaymentQueue.defaultQueue.finishTransaction(transaction)

      if wasSuccessful
        # ap "PurchaseManager finishTransaction if"
        @receipt = Receipt.new(transaction.transactionReceipt, @shared_secret) do |result|
          # ap "PurchaseManager finishTransaction result: #{result}"
          # ap "result.object: #{result.object}"
          result_object = BW::JSON.parse(result.object).to_object
          # ap "result_object.status: #{result_object.status}"

          # TODO - if subscription only be success if still active
          if result.success && result_object.status.to_i==0
            # ap "PurchaseManager finishTransaction result.success"
            App::Persistence["#{@product_id}.receipt_data"] = transaction.transactionReceipt
            App::Persistence["#{@product_id}.receipt"] = result.object
            @result.call({success: true, transaction: transaction}.to_object) unless @result.blank?
          else
            # ap "PurchaseManager finishTransaction result.failure"
            @result.call({success: false, transaction: transaction}.to_object) unless @result.blank?
          end
        end
      else
        # ap "PurchaseManager finishTransaction else"
        @result.call({success: wasSuccessful, transaction: transaction}.to_object) unless @result.blank?
      end
    end

    def completeTransaction(transaction)
      # ap "PurchaseManager completeTransaction"
      finishTransaction(transaction, wasSuccessful:true)
    end

    def restoreTransaction(transaction)
      # ap "PurchaseManager restoreTransaction"
      finishTransaction(transaction, wasSuccessful:true)
    end

    def failedTransaction(transaction)
      # ap "PurchaseManager failedTransaction transaction: #{transaction}"
      finishTransaction(transaction, wasSuccessful:false)
    end

    def paymentQueue(queue,updatedTransactions:transactions)
      # ap "PurchaseManager paymentQueue updatedTransactions"
      transactions.each do |transaction|
        case transaction.transactionState
          when SKPaymentTransactionStatePurchased
            # ap "SKPaymentTransactionStatePurchased"
            completeTransaction(transaction)
          when SKPaymentTransactionStateFailed
            # ap "SKPaymentTransactionStateFailed"
            failedTransaction(transaction)
          when SKPaymentTransactionStateRestored
            # ap "SKPaymentTransactionStateRestored"
            restoreTransaction(transaction)
          else 
        end
      end
    end

  end
end