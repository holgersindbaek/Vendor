describe "A - Vendor::Info" do

  before do
    @block = nil
    @info = nil
    @product = nil
    NSUserDefaults.standardUserDefaults.removePersistentDomainForName App.identifier
  end

  context "B - Product is invalid" do

    describe "C - In-app purchase" do

      before do
        @product = Vendor::Product.new(:id => "10_coins") do |block|
          @block = block
          @info = @product.info
          resume
        end
      end

      it "should have correct id" do
        wait_max(10) do
          @info.params.id.should.equal "10_coins"
        end
      end

      it "should return succes false" do 
        wait_max(10) do
          @block.success.should.equal false
        end
      end

      it "should not set info variables" do
        wait_max(10) do
          @info.price.should.equal "$0.99"
          @info.title.should.equal "No Title"
          @info.description.should.equal "No Description."
        end
      end

    end

    context "C - Subscription" do

      before do
        @product = Vendor::Product.new(:id => "monthly", :subscription => true, :secret => "test_secret") do |block|
          @block = block
          @info = @product.info
          resume
        end
      end

      it "should have subscription true" do
        wait_max(10) do
          @info.subscription?.should.equal true
        end
      end

      it "should not be subscribed" do
        wait_max(10) do
          @info.subscribed?.should.equal false
        end
      end

    end

  end

  context "B - Product is valid" do

    describe "C - In-app purchase" do

      before do
        @product = Vendor::Product.new(:id => "com.holgersindbaek.vendor.10_coins") do |block|
          @block = block
          @info = @product.info
          resume
        end
      end

      it "should have correct id" do

        wait_max(10) do
          @info.params.id.should.equal "com.holgersindbaek.vendor.10_coins"
        end
      end

      it "should return success true" do
        wait_max(10) do
          @block.success.should.equal true
        end
      end

      it "should set info variables" do
        wait_max(10) do
          @info.price.should.equal "$2.99"
          @info.title.should.equal "10 Coins"
          @info.description.should.equal "Buy 10 coins for your app."
        end
      end

    end

    context "C - Subscription" do

      before do
        @product = Vendor::Product.new(:id => "com.holgersindbaek.vendor.monthly", :subscription => true, :secret => "5bf47f7f8607453c93d5fc69c3426bde") do |block|
          @block = block
          @info = @product.info
          resume
        end
      end

      it "should have subscription true" do
        wait_max(10) do
          @info.subscription?.should.equal true
        end
      end

      it "should have correct shared secret" do
        wait_max(10) do
          @product.params.secret.should.equal "5bf47f7f8607453c93d5fc69c3426bde"
        end
      end

      it "should be subscribed if valid receipt date"

      it "should not be subscribed if invalid receipt date"

    end

  end

end