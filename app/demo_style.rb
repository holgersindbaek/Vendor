Teacup::Stylesheet.new :demo do

  style UIButton,
    width: "100%-20",
    height: 40,
    x: 10,
    layer: {
      borderWidth: 1,
      borderColor: "#c8c7cc".uicolor.CGColor,
      cornerRadius: 8
    }

  style UILabel,
    width: "100%-20",
    height: 20,
    x: 10,
    text: 'In-app purchase "ten_coins":',
    textAlignment: UITextAlignmentCenter,
    font: UIFont.boldSystemFontOfSize(15) 

  style :product_notice,
    y: 10,
    text: 'In-app purchase "ten_coins":'

  style :product_buy,
    y: 40,
    title: 'Buy'

  style :product_price,
    y: 90,
    title: 'Get localized price'

  style :product_description,
    y: 140,
    title: 'Get description'

  style :product_title,
    y: 190,
    title: 'Get title'

  style :product_bought,
    y: 240,
    title: 'Check if product is bought'

  style :subscription_notice,
    y: 340,
    text: 'Subscription "montly":'

  style :subscription_buy,
    y: 370,
    title: 'Buy'

  style :subscription_active,
    y: 420,
    title: 'Check if active'

  style :subscription_check,
    y: 470,
    title: 'Check if subscription'

end