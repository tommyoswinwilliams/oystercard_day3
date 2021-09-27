require "oystercard"

describe Oystercard do
  describe "#balance" do
    it "creates a new card with a balance of 0" do
      expect(subject.balance).to eq 0
    end
  end
  describe "#top_up" do
    it "allows topping up balance by integer amount given" do
      subject.top_up(5)
      expect(subject.balance).to eq 5
    end
    it "allows topping up balance by float amount given" do
      subject.top_up(5.5)
      expect(subject.balance).to eq 5.5
    end
    it "prevents topping up if balance limit will be exceeded" do
      subject.top_up(described_class::BALANCE_LIMIT)
      message = "Sorry, you cannot exceed the balance limit of £#{described_class::BALANCE_LIMIT}"
      expect { subject.top_up(1) }.to raise_error message
    end
    it "prevents topping up if amount not given" do
      message = "Please provide a valid amount"
      bad_amounts = ["five", 0, -2.5]
      bad_amounts.each do |amount|
        expect { subject.top_up(amount) }.to raise_error message
      end
    end
  end

  describe "#deduct" do
    it "reduces balance by amount of fare" do
      subject.top_up(10)
      subject.deduct(3.50)
      expect(subject.balance).to eq 6.50
    end

    it "doesn't allow the journey if balance lower than fare" do
      subject.top_up(3)
      message = "Sorry, your balance is not enough to cover the fare"
      expect { subject.deduct(3.50) }.to raise_error message
    end
  end

  describe "#touch_in" do
    it "updates internal boolean in_journey? to true" do
      subject.touch_in
      expect(subject.in_journey?).to be true 
    end
  end
end
