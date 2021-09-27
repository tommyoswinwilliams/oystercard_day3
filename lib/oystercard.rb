class Oystercard
  attr_reader :balance

  def initialize
    @balance = 0
  end

  def top_up(amount)
    fail "Please provide a valid amount" unless amount.is_a?(Integer) || amount.is_a?(Float)
    @balance += amount
  end
end
