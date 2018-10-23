require_relative 'card'

class Deck

  attr_accessor :cards

  def initialize
    @deck = (0..51).to_a.collect { |id| Card.new(id) }
    @ace = Proc.new { |a| a < 11 ? 11 : 1 }
  end

  def create_score
    @deck.each do |card|
      if card.value =~ /10|[JQK]/
        card.score = 10
      elsif card.value =~ /[2-9]/
        card.score = card.value.to_i
      else card.value = 'A'
        card.score = @ace
      end
    end
  end

  def shuffle_cards
    @deck.shuffle!
  end

  def take_card
    @deck.pop
  end
end
