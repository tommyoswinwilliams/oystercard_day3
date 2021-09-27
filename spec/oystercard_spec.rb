require 'oystercard'

describe Oystercard do
  describe "#balance" do
    it "creates a new card with a balance of 0" do
      expect(subject.balance).to eq 0
    end
  end
end

# NameError without Oystercard class
# Error occurred at ./spec/oystercard_spec.rb
# Error occurred at line 1
# NameError: Raised when a given name is invalid or undefined.
# Error can be solved by creating a class called Oystercard