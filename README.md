# Vendor

## Installation

Add this line to your application's Gemfile:

    gem 'rm_vendor'

And then execute:

    $ bundle

Require in your rakefile:

    require 'vendor'

Install pod dependencies:

    $ rake pod:install
    
## USAGE

#### Initialize.

Initialize your products with your In App Purchase ID. Vendor will check if the product exists and return it's attributes:
    
```Ruby
@products = Vendor::Products.new([{:name => "first_item", :id => "com.your.first_item.id"}, {:name => "second_item", :id => "com.your.second_item.id"}]) do |products|
  products.map{ |product| NSLog "Product exists?: #{product.success}" }
  products.map{ |product| NSLog "Product error: #{product.error}" }
  products.map{ |product| NSLog "Product response: #{product.response}" }
end
```

You don't need to pass along a block though. If you're sure your product exists, then you can just do this:
      
```Ruby
@products = Vendor::Products.new([{:name => "first_item", :id => "com.your.first_item.id"}, {:name => "second_item", :id => "com.your.second_item.id"}])
```

If you want to initialize your product with data such as price and description, you can do that as well:
      
```Ruby
@products = Vendor::Products.new([{:name => "first_item", :id => "com.your.first_item.id", :price => "0.99", :title ="Title of my first item", :description => "My first items description"}])
```

#### Get product info.

After you've initialized your product, you get its information:
  
```Ruby
@product[:first_item].price
@product[:first_item].title
@product[:first_item].description
@product[:first_item].bought?
```

#### Purchase product.

To purchase a product, simply do:

```Ruby
@product[:first_item].purchase do |product|
  p "Purchase successful: #{product.success}"
  p "Purchase transaction: #{product.transaction}"
end
```

#### Subscriptions.

Vendor also works with subscriptions. To initialize a subscription:

```Ruby
@subscription_products = Vendor::Products.new([{:name => "subscription", :id => "com.your.subscription.id", :secret => "abcdefg12345", :subscription => true}]) do |subscriptions|
  subscriptions.map{ |subscription| NSLog "Subscription exists?: #{subscription.success}" }
  subscriptions.map{ |subscription| NSLog "Subscription error: #{subscription.error}" }
  subscriptions.map{ |subscription| NSLog "Subscription response: #{subscription.response}" }
end
```

To purchase a subscription:

```Ruby
@subscription_products[:subscription].purchase do |subscription|
  p "Subscription successful: #{subscription.success}"
  p "Subscription transaction: #{subscription.transaction}"
end
```

To see wether product is registered as a subscription and if user is currently subscribed:

```Ruby
@subscription_products[:subscription].subscribed?
@subscription_products[:subscription].subscription?
```

## Example App.

You can find an example app inside this gem (inside the app folder).
