class DemoController < UIViewController
  stylesheet :demo

  layout do
    @product_notice = subview(UILabel, :product_notice)
    @product_buy = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :product_buy)
    @product_price = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :product_price)
    @product_description = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :product_description)
    @product_title = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :product_title)
    @product_bought = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :product_bought)

    @subscription_notice = subview(UILabel, :subscription_notice)
    @subscription_buy = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :subscription_buy)
    @subscription_active = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :subscription_active)
    @subscription_check = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :subscription_check)
  end

  def viewDidLoad
    super

    # Instantiate products
    subscription_name = MY_ENV['SUBSCRIPTION_NAME'] || "subscription"
    subscription_id = MY_ENV['SUBSCRIPTION_ID'] || "com.your.subscription.id"
    subscription_secret = MY_ENV['SUBSCRIPTION_SECRET'] || "abcdefg12345"
    product_name = MY_ENV['ITEM_NAME'] || "coins"
    product_id = MY_ENV['ITEM_ID'] || "com.your.item.id"
    @products = Vendor::Products.new([{:name =>  subscription_name, :id => subscription_id, :secret => subscription_secret, :subscription => true}, {:name =>  product_name, :id => product_id}]) do |products|
      products.map{ |p| NSLog "p: #{p}" }
    end

    @product_buy.when(UIControlEventTouchUpInside){
      @products[product_name].purchase do |block|
        NSLog "Product Purchased: #{block[:success]}"
        NSLog "Block: #{block}"
      end
    }

    @product_price.when(UIControlEventTouchUpInside){
      NSLog @products[product_name].price
    }

    @product_description.when(UIControlEventTouchUpInside){
      NSLog @products[product_name].description
    }

    @product_title.when(UIControlEventTouchUpInside){
      NSLog @products[product_name].title
    }

    @product_bought.when(UIControlEventTouchUpInside){
      NSLog "#{@products[product_name].bought?}"
    }

    @subscription_buy.when(UIControlEventTouchUpInside){
      @products[subscription_name].purchase do |block|
        NSLog "Subscription Purchased: #{block[:success]}"
        NSLog "Block: #{block}"
      end
    }

    @subscription_active.when(UIControlEventTouchUpInside){
      NSLog "#{@products[subscription_name].subscribed?}"
    }

    @subscription_check.when(UIControlEventTouchUpInside){
      NSLog "#{@products[subscription_name].subscription?}"
    }

  end

  def shouldAutorotate
    false
  end

end