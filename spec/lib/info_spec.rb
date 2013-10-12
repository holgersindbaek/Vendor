describe "A - Vendor::Info" do

  it "should initialize and set secret and id" do
    @info = Vendor::Info.new("10_coins", "no_secret") do |block|
      block.success.should.equal false
    end
    @info.id.should.equal "10_coins"
    @info.secret.should.equal "no_secret"

    # wait_max(5) do
    #   @info.block.success.should.equal false
    # end
  end

  describe "B - Delegate methods" do

    it "should return succes false if not real product" do 
      @block = nil
      @info = Vendor::Info.new("10_coins", "no_secret") do |block|
        @block = block
        resume
      end

      wait_max(5) do
        NSLog "@block.success: #{@block.success}"

        # This terminates the app and throws an error
        @block.success.should.equal true

        # And so does this
        false.should.equal true
      end
    end

    it "should return succes true if real product" do
      false.true?
      # @block = nil
      # @info = Vendor::Info.new("10_coins", "no_secret") do |block|
      #   @block = block
      #   resume
      # end

      # wait_max(5) do
      #   @block.nil?.should.not.be.same_as false
      #   @block.success.should.equal false
      # end
      
      # # false.should.not.equal false
      # @block = nil
      # # @info = Vendor::Info.new("com.holgersindbaek.vendor.10_coins", "no_secret") do |block|
      # #   @block = block
      # #   resume
      # # end

      # # wait_max(5) do
      #   @block.nil?.should.equal false
      #   @block.success.should.equal true
      # # end
    end


  end
end