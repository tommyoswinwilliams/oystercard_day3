require "oystercard"

describe Oystercard do
  let(:kings_cross) { double :station, :id => :kings_cross, :zone => 1}
  let(:victoria) { double :station, :id => :victoria, :zone => 1 }
  # let!(:station) { instance_double(Station, :zone => 1, id: :kings_cross)}

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
  
  describe "#touch_in" do
    context "when errors" do
      it "raises error when card with insufficient balance is touched in" do
        message = "Sorry, you don't have the minimum balance required of £#{described_class::MIN_BALANCE}"
        expect { subject.touch_in(kings_cross) }.to raise_error message
      end
      
      it "Deduct MAX_PENALTY if already in journey" do  
        subject.top_up(described_class::MAX_PENALTY*2)
        subject.touch_in(kings_cross)
        expect { subject.touch_in(kings_cross) }.to change { subject.balance }.by(-described_class::MAX_PENALTY)
      end

      it "Deduct MAX_PENALTY if already in journey and throws insufficient money" do  
        subject.top_up(described_class::MIN_BALANCE)
        subject.touch_in(kings_cross)
        message = "Sorry, you don't have the minimum balance required of £#{described_class::MIN_BALANCE}"
        expect { subject.touch_in(kings_cross) }.to raise_error message
      end
    end
    
    context "when no errors" do
      before(:each) do
        subject.top_up(described_class::MIN_BALANCE)
        subject.touch_in(kings_cross)
      end
    end
  end

  describe "#touch_out" do
    let(:heathrow) { double :station, :id => :heathrow, :zone => 6}
    let(:wimbledon) { double :station, :id => :wimbledon, :zone => 3 }

    it "deducts MAX_PENALTY when not in journey" do
      expect { subject.touch_out(victoria) }.to change { subject.balance }.by(-described_class::MAX_PENALTY)
    end

    it "deducts 1 from balance from zone 1 to 1" do
      subject.top_up(described_class::MIN_BALANCE)
      subject.touch_in(kings_cross)
      fare = described_class::MIN_BALANCE
      expect { subject.touch_out(victoria) }.to change { subject.balance }.by(-fare)
    end

    it "deducts 4 from balance from zone 3 to 6" do
      subject.top_up(described_class::MIN_BALANCE)
      subject.touch_in(heathrow)
      expect { subject.touch_out(wimbledon) }.to change { subject.balance }.by(-4)
    end
  end

  describe "#add_journey" do
    context "when no errors" do
      before(:each) do
        subject.top_up(described_class::MIN_BALANCE)
        subject.touch_in(kings_cross)
      end
    end
  end
end
