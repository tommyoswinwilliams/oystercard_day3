
class Journey
  attr_reader :journeys

  def initialize
    @journeys = []
    @entry_station
  end

  def enter_station(entry_station)
    @entry_station = entry_station
  end

  def exit_station_and_calculate_fare(exit_station)
    cost = calculate_fare(exit_station)
    save_journey(exit_station)
    return cost
  end

  def in_journey?
    @entry_station != nil
  end
  
  private

  def calculate_fare(exit_station)
    if(@entry_station == nil || exit_station == nil)
      return 0
    end
    return (@entry_station.zone - exit_station.zone).abs + Oystercard::MIN_BALANCE
  end

  def save_journey(exit_station)
    @journeys.push({entry: @entry_station, exit: exit_station})
    @entry_station = nil
  end
  
end