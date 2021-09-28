require "oystercard"

describe Oystercard do
  let(:kings_cross) { double :station, :id => :kings_cross }
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

  # it "doesn't allow the journey if balance lower than fare" do
  #   subject.top_up(3)
  #   message = "Sorry, your balance is not enough to cover the fare"
  #   expect { subject.deduct(3.50) }.to raise_error message
  # end

  describe "#touch_in" do
    it "updates internal boolean in_journey? to true" do
      subject.top_up(described_class::MIN_BALANCE)
      subject.touch_in(kings_cross)
      expect(subject).to be_in_journey
    end

    it "raises error when already in_journey?" do
      message = "You are already in a journey"

      subject.top_up(described_class::MIN_BALANCE)
      subject.touch_in(kings_cross)

      expect { subject.touch_in(kings_cross) }.to raise_error message
    end

    it "raises error when card with insufficient balance is touched in" do
      message = "Sorry, you don't have the minimum balance required of £#{described_class::MIN_BALANCE}"
      expect { subject.touch_in(kings_cross) }.to raise_error message
    end

    it "remembers entry station" do
      subject.top_up(described_class::MIN_BALANCE)
      subject.touch_in(kings_cross)
      expect(subject.entry_station).to eq kings_cross
    end
  end

  describe "#touch_out" do
    it "updates internal boolean in_journey? to false" do
      subject.top_up(described_class::MIN_BALANCE)
      subject.touch_in(kings_cross)
      subject.touch_out
      expect(subject).not_to be_in_journey
    end

    it "raises error when not in_journey?" do
      message = "You are not in a journey"

      expect { subject.touch_out }.to raise_error message
    end
    it "deducts fare from balance" do
      fare = described_class::MIN_BALANCE
      subject.top_up(fare)
      subject.touch_in(kings_cross)
      expect { subject.touch_out }.to change { subject.balance }.by(-fare)
    end
  end
end
