describe :keep_if, :shared => true do
  it "deletes elements for which the block returns a false value" do
    array = [1, 2, 3, 4, 5]
    array.send(@method) {|item| item > 3 }.should equal(array)
    array.should == [4, 5]
  end

  it "returns an enumerator if no block is given" do
    [1, 2, 3].send(@method).should be_an_instance_of(enumerator_class)
  end

  it "returns the correct size when no block is given" do
    [1, 2, 3].send(@method).size.should == 3
  end

  describe "on frozen objects" do
    before(:each) do
      @origin = [true, false]
      @frozen = @origin.dup.freeze
    end

    it "returns an Enumerator if no block is given" do
      @frozen.send(@method).should be_an_instance_of(enumerator_class)
    end

    describe "with truthy block" do
      it "keeps elements after any exception" do
        lambda { @frozen.send(@method) { true } }.should raise_error(Exception)
        @frozen.should == @origin
      end

      it "raises a RuntimeError" do
        lambda { @frozen.send(@method) { true } }.should raise_error(RuntimeError)
      end
    end

    describe "with falsy block" do
      it "keeps elements after any exception" do
        lambda { @frozen.send(@method) { false } }.should raise_error(Exception)
        @frozen.should == @origin
      end

      it "raises a RuntimeError" do
        lambda { @frozen.send(@method) { false } }.should raise_error(RuntimeError)
      end
    end
  end
end
