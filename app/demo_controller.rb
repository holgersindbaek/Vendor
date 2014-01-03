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

    @product = Vendor::Product.new(:id => "com.your.item.id") do |block|
      NSLog "product: #{block.success}"
      NSLog "block: #{block}"
    end

    @product_buy.when(UIControlEventTouchUpInside){
      @product.purchase do |block|
        NSLog "Purchased product"
      end
    }

    @product_price.when(UIControlEventTouchUpInside){
      NSLog @product.price
    }

    @product_description.when(UIControlEventTouchUpInside){
      NSLog @product.description
    }

    @product_title.when(UIControlEventTouchUpInside){
      NSLog @product.title
    }

    @product_bought.when(UIControlEventTouchUpInside){
      NSLog "#{@product.bought?}"
    }



    @subscription = Vendor::Product.new(:id => "com.your.subscription.id", :secret => "abcdefg12345", :subscription => true) do |block|
      NSLog "subscription: #{block.success}"
    end

    @subscription_buy.when(UIControlEventTouchUpInside){
      @subscription.purchase do |block|
        NSLog "Purchased subscription"
      end
    }

    @subscription_active.when(UIControlEventTouchUpInside){
      NSLog "#{@subscription.subscribed?}"
    }

    @subscription_check.when(UIControlEventTouchUpInside){
      NSLog "#{@subscription.subscription?}"
    }

  end

  def shouldAutorotate
    false
  end

end