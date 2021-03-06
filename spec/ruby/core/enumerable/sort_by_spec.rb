require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Enumerable#sort_by" do
  it "returns an array of elements ordered by the result of block" do
    a = EnumerableSpecs::Numerous.new("once", "upon", "a", "time")
    a.sort_by { |i| i[0] }.should == ["a", "once", "time", "upon"]
  end

  it "sorts the object by the given attribute" do
    a = EnumerableSpecs::SortByDummy.new("fooo")
    b = EnumerableSpecs::SortByDummy.new("bar")

    ar = [a, b].sort_by { |d| d.s }
    ar.should == [b, a]
  end

  it "returns an Enumerator when a block is not supplied" do
    a = EnumerableSpecs::Numerous.new("a","b")
    a.sort_by.should be_an_instance_of(enumerator_class)
    a.to_a.should == ["a", "b"]
  end

  it "gathers whole arrays as elements when each yields multiple" do
    multi = EnumerableSpecs::YieldsMulti.new
    multi.sort_by {|e| e.size}.should == [[1, 2], [3, 4, 5], [6, 7, 8, 9]]
  end

  it "returns the correct size when no block is given" do
    enum = EnumerableSpecs::NumerousWithSize.new(1, 2, 3, 4, 5, 6)
    enum.sort_by.size.should == 6
  end
end
