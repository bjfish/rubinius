require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Enumerable#each_with_object" do
  before :each do
    @values = [2, 5, 3, 6, 1, 4]
    @enum = EnumerableSpecs::Numerous.new(*@values)
    @initial = "memo"
  end

  it "passes each element and its argument to the block" do
    acc = []
    @enum.each_with_object(@initial) do |elem, obj|
      obj.should equal(@initial)
      obj = 42
      acc << elem
    end.should equal(@initial)
    acc.should == @values
  end

  it "returns an enumerator if no block" do
    acc = []
    e = @enum.each_with_object(@initial)
    e.each do |elem, obj|
      obj.should equal(@initial)
      obj = 42
      acc << elem
    end.should equal(@initial)
    acc.should == @values
  end

  it "gathers whole arrays as elements when each yields multiple" do
    multi = EnumerableSpecs::YieldsMulti.new
    array = []
    multi.each_with_object(array) { |elem, obj| obj << elem }
    array.should == [[1, 2], [3, 4, 5], [6, 7, 8, 9]]
  end

  it "returns the correct size when no block is given" do
    enum = EnumerableSpecs::NumerousWithSize.new(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
    enum.each_with_object([]).size.should == 10
  end
end
