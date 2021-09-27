class Oystercard
  BALANCE_LIMIT = 90
  attr_reader :balance

  def initialize
    @balance = 0
    @error_messages = {
      valid_amount: "Please provide a valid amount",
      exceed_limit: "Sorry, you cannot exceed the balance limit of £#{BALANCE_LIMIT}",
      insufficient_balance: "Sorry, your balance is not enough to cover the fare" 
    }
    @in_journey = false
  end
  
  def top_up(amount)
    fail @error_messages[:valid_amount] unless valid_amount?(amount)
    fail @error_messages[:exceed_limit] if exceed_limit?(amount)
    @balance += amount
  end
  
  def deduct(fare)
    fail @error_messages[:insufficient_balance] if fare_exceeds?(fare)
    @balance -= fare
  end
  
  def touch_in
    @in_journey = true
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
