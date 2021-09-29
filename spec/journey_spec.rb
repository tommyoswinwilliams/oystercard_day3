require "journey"

describe Journey do

  let(:kings_cross) { double :station, :id => :kings_cross }
  let(:victoria) { double :station, :id => :victoria }

  describe "#initialize" do
    it "has an empty list of journeys" do
      expect(subject.instance_variable_get(:@journeys)).to eq []
    end
  end

  describe '#enter_station' do
    it "sets entry station" do
      subject.enter_station(kings_cross)
      expect(subject.instance_variable_get(:@entry_station)).to eq kings_cross
    end
  end

  describe '#exit_station' do
    it "sets exit station nil" do
      subject.enter_station(kings_cross)
      subject.exit_station(victoria)
      expect(subject.instance_variable_get(:@entry_station)).to eq nil
    end

    it "stores journey on touch out" do
      subject.enter_station(kings_cross)
      subject.exit_station(victoria)
      expect(subject.instance_variable_get(:@journeys)).to eq [{entry: kings_cross, exit: victoria}]
    end

    it "updates oystercard to not be in journey" do
      subject.exit_station(victoria)
      expect(subject).not_to be_in_journey
    end
  end
end