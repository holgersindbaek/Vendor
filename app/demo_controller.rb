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

    @product = Vendor::Product.new(:id => "com.holgersindbaek.vendor.10_coins") do |block|
      ap block.success
    end

    @product_buy.when(UIControlEventTouchUpInside){  }
    @product_price.when(UIControlEventTouchUpInside){ 
      ap @product.info.price
    }
    @product_description.when(UIControlEventTouchUpInside){  }
    @product_title.when(UIControlEventTouchUpInside){  }
    @product_bought.when(UIControlEventTouchUpInside){  }

    @subscription_buy.when(UIControlEventTouchUpInside){  }
    @subscription_active.when(UIControlEventTouchUpInside){  }
    @subscription_check.when(UIControlEventTouchUpInside){  }

  end

  def shouldAutorotate
    false
  end

end