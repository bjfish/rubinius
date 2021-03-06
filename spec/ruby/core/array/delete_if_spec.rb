require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)
require File.expand_path('../shared/enumeratorize', __FILE__)

describe "Array#delete_if" do
  before do
    @a = [ "a", "b", "c" ]
  end

  it "removes each element for which block returns true" do
    @a = [ "a", "b", "c" ]
    @a.delete_if { |x| x >= "b" }
    @a.should == ["a"]
  end

  it "returns self" do
    @a.delete_if{ true }.equal?(@a).should be_true
  end

  it_behaves_like :enumeratorize, :delete_if

  it "returns self when called on an Array emptied with #shift" do
    array = [1]
    array.shift
    array.delete_if { |x| true }.should equal(array)
  end

  it "returns an Enumerator if no block given, and the enumerator can modify the original array" do
    enum = @a.delete_if
    enum.should be_an_instance_of(enumerator_class)
    @a.should_not be_empty
    enum.each { true }
    @a.should be_empty
  end

  it "returns an Enumerator if no block given, and the array is frozen" do
    @a.freeze.delete_if.should be_an_instance_of(enumerator_class)
  end

  it "raises a RuntimeError on a frozen array" do
    lambda { ArraySpecs.frozen_array.delete_if {} }.should raise_error(RuntimeError)
  end

  it "raises a RuntimeError on an empty frozen array" do
    lambda { ArraySpecs.empty_frozen_array.delete_if {} }.should raise_error(RuntimeError)
  end

  it "keeps tainted status" do
    @a.taint
    @a.tainted?.should be_true
    @a.delete_if{ true }
    @a.tainted?.should be_true
  end

  it "keeps untrusted status" do
    @a.untrust
    @a.untrusted?.should be_true
    @a.delete_if{ true }
    @a.untrusted?.should be_true
  end

  it "returns the correct size when no block is given" do
    [1, 2, 3].delete_if.size.should == 3
  end
end
