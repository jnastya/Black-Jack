class Card

attr_accessor :suit, :value, :score

  SUITS = ['♣️', '♥️', '♠️', '♦️']
  VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

  def initialize(id)
    @suit = SUITS[id % 4]
    @value = VALUES[id % 13]
    @score = 0
  end
end
