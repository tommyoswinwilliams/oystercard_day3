require "journey"

describe Journey do

  let(:kings_cross) { double :station, :id => :kings_cross, :zone => 1}
  let(:victoria) { double :station, :id => :victoria, :zone => 1 }
  let(:heathrow) { double :station, :id => :heathrow, :zone => 6}
  let(:wimbledon) { double :station, :id => :wimbledon, :zone => 3 }

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

  describe '#exit_station_and_calculate_fare' do
    it "sets exit station nil" do
      subject.enter_station(kings_cross)
      subject.exit_station_and_calculate_fare(victoria)
      expect(subject.instance_variable_get(:@entry_station)).to eq nil
    end

    it "stores journey on touch out" do
      subject.enter_station(kings_cross)
      subject.exit_station_and_calculate_fare(victoria)
      expect(subject.instance_variable_get(:@journeys)).to eq [{entry: kings_cross, exit: victoria}]
    end

    it "updates oystercard to not be in journey" do
      subject.exit_station_and_calculate_fare(victoria)
      expect(subject).not_to be_in_journey
    end

    it 'return fare 1 when same zone' do
      subject.enter_station(kings_cross)
      expect(subject.exit_station_and_calculate_fare(victoria)).to eq 1
    end

    it 'return fare 6 from zone 1 to 6' do
      subject.enter_station(kings_cross)
      expect(subject.exit_station_and_calculate_fare(heathrow)).to eq 6
    end

    it 'return fare 3 from zone 3 to 1' do
      subject.enter_station(wimbledon)
      expect(subject.exit_station_and_calculate_fare(victoria)).to eq 3
    end

    it 'return fare 0 when exit station is nil' do
      subject.enter_station(wimbledon)
      expect(subject.exit_station_and_calculate_fare(nil)).to eq 0
    end

    it 'return fare 0 when entry station is nil' do
      subject.enter_station(nil)
      expect(subject.exit_station_and_calculate_fare(heathrow)).to eq 0
    end
  end
end