require 'journey'

class Oystercard
  BALANCE_LIMIT = 90
  MAX_PENALTY = 6
  MIN_FARE = 1
  MIN_BALANCE = 1
  attr_reader :balance
  def initialize
    @balance = 0
    @error_messages = {
      valid_amount: "Please provide a valid amount",
      exceed_limit: "Sorry, you cannot exceed the balance limit of £#{BALANCE_LIMIT}",
      insufficient_fare_balance: "Sorry, your balance is not enough to cover the fare",
      in_journey: "You are already in a journey",
      not_in_journey: "You are not in a journey",
      insufficient_min_balance: "Sorry, you don't have the minimum balance required of £#{MIN_BALANCE}",
    }
    @journey = Journey.new
  end

  def top_up(amount)
    fail @error_messages[:valid_amount] unless valid_amount?(amount)
    fail @error_messages[:exceed_limit] if exceed_limit?(amount)
    @balance += amount
  end

  def touch_in(entry_station)
    if @journey.in_journey?
      deduct(MAX_PENALTY)
    end
    fail @error_messages[:insufficient_min_balance] if fare_exceeds?(MIN_BALANCE)
    @journey.enter_station(entry_station)
  end

  def touch_out(exit_station)
    fare = MIN_FARE
    if !@journey.in_journey?
      fare = MAX_PENALTY
    end
    deduct(fare)
    @journey.exit_station(exit_station)
  end

  private

  def deduct(fare)
    @balance -= fare
  end

  def valid_amount?(amount)
    (amount.is_a?(Integer) || amount.is_a?(Float)) && (amount.positive?)
  end

  def exceed_limit?(amount)
    @balance + amount > BALANCE_LIMIT
  end

  def fare_exceeds?(fare)
    @balance < fare
  end
end
