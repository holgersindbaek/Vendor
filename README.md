# Bling Bling

## Installation

Add this line to your application's Gemfile:

    gem 'BlingBling'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install BlingBling

## USAGE

#### Initialize.

Start a BlingBling with the In App Purchase ID. Helu will check if the product exists and return the success:

    @loose_weight = Helu.new("loosing_weight_10") { |result| puts result[:success] }

You can also get more info on the product:

  @loose_weight = Helu.new("loosing_weight_10") do |result| 
    if result[:success]
      puts result[:response]
    else
      puts result[:error]
    end
  end

#### Get products (localized) price, title and description.

After you've made sure your product exists, you can now get it's price, title and description:

  @loose_weight.price
  @loose_weight.title
  @loose_weight.description

#### Purchase product.

To purchase a product do:

  @loose_weight.purchase { |result| puts result[:success] }

And if you want some more info

  @loose_weight.purchase do |result|
    if result[:success]
      puts result[:transaction]
    else
      puts result[:transaction]
    end
  end

## Example App: 

[You can find an example app here](https://github.com/ivanacostarubio/helu-example). Remember that for this to work properly, you must add your app identifier to the Rakefile.
    
    
## Supported types of In App Purchases

+ Consumables and Non-Consumables are supported. 
+ Auto-Renewable subscriptions and Non-Renewing Subscriptions are not supported yet. However, we would love some help making it happen. 
