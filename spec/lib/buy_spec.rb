describe "A - Vendor::Buy" do

  # before do
  #   if @product
  #     @product.buy.close
  #     @product = nil
  #     @block = nil
  #   end
  #   NSUserDefaults.standardUserDefaults.removePersistentDomainForName App.identifier
  # end

  # # context "B - Product is invalid" do

  # #   before do
  # #     @product = Vendor::Product.new(:id => "10_coins")
  # #   end

  # #   it "should initialize with correct id" do
  # #     @product.buy.params.id.should.equal "10_coins"
  # #   end

  # #   it "should return false on purchasing product" do
  # #     @product.buy.purchase do |block|
  # #       @block = block
  # #       resume
  # #     end

  # #     wait_max(20) do
  # #       @block.success.should.equal false
  # #     end
  # #   end

  # # end

  # context "B - Product is valid" do

  #   before do
  #     @product = Vendor::Product.new(:id => "com.holgersindbaek.vendor.10_renewable_coins")
  #   end

  #   it "should initialize with correct id" do
  #     NSLog "should initialize with correct id"
  #     @product.buy.params.id.should.equal "com.holgersindbaek.vendor.10_renewable_coins"
  #   end

  #   it "should return true on purchasing product" do
  #     NSLog "should return true on purchasing product"
  #     # @product = Vendor::Product.new(:id => "com.holgersindbaek.vendor.10_renewable_coins")
  #     @product.buy.purchase do |block|
  #       NSLog "AAA - Product should be bought now"
  #       @block = block
  #       resume
  #     end

  #     wait_max(20) do
  #       NSLog "AAA - Going on with code"
  #       @block.success.should.equal true
  #     end
  #   end

  # end

end