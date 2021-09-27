class Oystercard
  BALANCE_LIMIT = 90
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
    @in_journey = false
  end

  def top_up(amount)
    fail @error_messages[:valid_amount] unless valid_amount?(amount)
    fail @error_messages[:exceed_limit] if exceed_limit?(amount)
    @balance += amount
  end

  def deduct(fare)
    fail @error_messages[:insufficient_fare_balance] if fare_exceeds?(fare)
    @balance -= fare
  end

  def touch_in
    fail @error_messages[:in_journey] if in_journey?
    fail @error_messages[:insufficient_min_balance] if fare_exceeds?(MIN_BALANCE)
    @in_journey = true
  end

  def touch_out
    fail @error_messages[:not_in_journey] unless in_journey?
    @in_journey = false
  end

  def in_journey?
    @in_journey
  end

  private

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
