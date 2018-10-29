require_relative 'card'

class Deck

  attr_accessor :card

  SUITS = ['♣️', '♥️', '♠️', '♦️']
  VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

  def initialize
    @deck = create_deck.shuffle!
  end

  def create_deck
     SUITS.map{|suit| VALUES.map{|value| Card.new(suit, value)}}.flatten
  end

  def take_card
    @deck.pop
  end
end
