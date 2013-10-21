describe "A - Vendor::Product" do

  # before do
  #   @product = Vendor::Product.new()
  # end

  describe "B - intialize" do 

    # it "should set local params to passed params" do 
    #   @product = Vendor::Product.new(:id => "10_coins", :secret => "4dwa132eeqw", :subscription => false, :price => "1.99", :title => "Ten Coins", :description => "Buy 10 coins for your app.")
    #   @product.id_param.should.equal "10_coins"
    #   @product.secret_param.should.equal "4dwa132eeqw"
    #   @product.subscription_param.should.equal false
    #   @product.price_param.should.equal "1.99"
    #   @product.title_param.should.equal "Ten Coins"
    #   @product.description_param.should.equal "Buy 10 coins for your app."
    # end

    # it "should raise error if no id param" do
    #   lambda{Vendor::Product.new}.should.raise(ArgumentError).message.should.match(/VENDOR WARNING: You forgot to write in your item id. You can't sell item without an id./)
    # end

    # it "should raise error if subscription param, but no secret param" do
    #   lambda{Vendor::Product.new(:id => "subscription_id", :subscription => true)}.should.raise(ArgumentError).message.should.match(/VENDOR WARNING: You're missing your subscriptions shared secret. Subscriptions must have a shared secret./)
    # end

    # # it "should initialize info and buy if id is correct" do 
    # #   @product = Vendor::Product.new(:id => "10_coins")
    # #   @product.info.nil?.should.equal false
    # #   @product.buy.nil?.should.equal false
    # # end

    # it "should init product info and return block" do
    #   @block = nil
    #   @product = Vendor::Product.new(:id => "10_coins") do |block|
    #     @block = block
    #     resume
    #   end

    #   wait_max(10) do
    #     @block.nil?.should.equal false
    #   end
    # end
    
    # it "should set @exists? to false if product does not exist" do 
    #   @block = nil
    #   @product = Vendor::Product.new(:id => "10_coins") do |block|
    #     @block = block
    #     resume
    #   end

    #   wait_max(10) do
    #     block.nil?.should.equal false
    #     @product.exists?.should.equal false
    #   end
    # end

    # it "should set @exists? to true if product does exist" do
    #   @block = nil
    #   @product = Vendor::Product.new(:id => "com.holgersindbaek.vendor.10_coins") do |block|
    #     @block = block
    #     resume
    #   end

    #   wait_max(10) do
    #     block.nil?.should.equal false
    #     false.should != false
    #   end
    # end
    
  end

end