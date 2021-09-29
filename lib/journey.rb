
class Journey


  def initialize
    @journeys = []
    @entry_station
  end

  def enter_station(entry_station)
    @entry_station = entry_station
  end

  def exit_station(exit_station)
    save_journey(exit_station)
    @entry_station = nil
  end

  def in_journey?
    @entry_station != nil
  end
  
  private
  def save_journey(exit_station)
    @journeys.push({entry: @entry_station, exit: exit_station})
  end
  
end