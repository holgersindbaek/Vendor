# Vendor

## Installation

Add this line to your application's Gemfile:

    gem 'Vendor'

And then execute:

    $ bundle

## USAGE

#### Initialize.

Initialize your product with your In App Purchase ID. Vendor will check if the product exists and return it's attributes:
    
    ```Ruby
    @product = Vendor::Product.new(:id => "com.your.item.id") do |product|
      p "Product exists: #{product.success}"
      p "Product response: #{product.response}"
    end
    ```

You don't need to pass along a block though. If you're sure your product exists, then you can just do this:
      
    ```Ruby
    @product = Vendor::Product.new(:id => "com.your.item.id")
    ```

#### Get product info.

After you've initialized your product, you get its information:
  
    ```Ruby
    @product.price
    @product.title
    @product.description
    @product.bought?
    ```

#### Purchase product.

To purchase a product, simply do:

    ```Ruby
    @product.purchase do |product|
      p "Purchase successful: #{product.success}"
      p "Purchase transaction: #{product.transaction}"
    end
    ```

#### Subscriptions.

Vendor also works with subscriptions. To initialize a subscription:

    ```Ruby
    @subscription = Vendor::Product.new(:id => "com.your.subscription.id", :secret => "abcdefg12345", :subscription => true) do |subscription|
      p "Subscription exists: #{subscription.success}"
      p "Subscription response: #{subscription.response}"
    end
    ```

To purchase a subscription:

    ```Ruby
    @subscription.purchase do |subscription|
      p "Subscription successful: #{subscription.success}"
      p "Subscription transaction: #{subscription.transaction}"
    end
    ```

To see wether product is registered as a subscription and if user is currently subscribed:

    ```Ruby
    @subscription.subscribed?
    @subscription.subscription?
    ```

## Example App.

You can find an example app inside this gem (inside the app folder).