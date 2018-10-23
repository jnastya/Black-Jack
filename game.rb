require_relative 'deck'
class Game

  attr_accessor :player, :dealer, :bank, :open_cards
  attr_reader :status, :deck

  BID = 10

  def initialize(player_name)
    @bank = 0
    @deck = Deck.new
    @player = Player.new(player_name)
    @dealer = Player.new('Dealer')
    @open_cards = false
  end

  # Statuses:
  # 1 - Player win
  # 2 - Draw
  # 3 - Dealer win

  def results
    @dealer.can_show_dealer_cards = true
    if @player.get_current_score > 21
      @dealer.money += @bank
      @status = 3
    elsif @dealer.get_current_score > 21
      @player.money += @bank
      @status = 1
    elsif @player.get_current_score > @dealer.get_current_score
      @player.money += @bank
      @status = 1
    elsif @player.get_current_score < @dealer.get_current_score
      @dealer.money += @bank
      @status = 3
    else @player.get_current_score == @dealer.get_current_score
      @player.money += BID
      @dealer.money += BID
      @status = 2
    end
  end

  def start_game
    @deck.create_score
    @deck.shuffle_cards
    @status = 0
    @bank = 0
    2.times { @player.hand << @deck.take_card }
    2.times { @dealer.hand << @deck.take_card }
    @bank = BID * 2
    @player.money -= BID
    @dealer.money -= BID
  end

  def reset
    @deck = Deck.new
    @player.hand = []
    @dealer.hand = []
    @dealer.can_show_dealer_cards = false
  end
end
