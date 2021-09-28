require "station"

describe Station do
  it "creates station with name" do
    station = Station.new("Kings Cross", 1)
    expect(station.name).to eq "Kings Cross"
  end
  it "creates station with zone" do
    station = Station.new("Kings Cross", 1)
    expect(station.zone).to eq 1
  end
end
