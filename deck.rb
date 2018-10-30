require_relative 'card'

class Deck

  attr_accessor :card

  def initialize
    @deck = create_deck.shuffle!
  end

  def create_deck
    Card::SUITS.map{|suit| Card::VALUES.map{|value| Card.new(suit, value)}}.flatten
  end

  def take_card
    @deck.pop
  end
end
