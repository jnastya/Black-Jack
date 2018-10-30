require_relative 'deck'
class Game

  attr_accessor :player, :dealer, :bank, :open_cards
  attr_reader :status, :deck, :message, :desk

  BID = 10

  def initialize(player_name)
    @bank = 0
    @deck = Deck.new
    @player = Player.new(player_name)
    @dealer = Player.new('Dealer')
    @open_cards = false
    @message = ""
    @desk = desk
  end


  def actions(step)
    while @player.hand.length < 3 && @dealer.hand.length < 3 do
      player_turn(step)
      dealer_turn
      break if @open_cards
    end
  end

  def player_turn(step)
    if step == 1
      @message = "Ход переходит дилеру"
    elsif step == 2
      if @player.hand.length < 3
        @player.hand << @deck.take_card
        @desk # update ui
      else
        @message = "Число карт игрока превышено"
      end
      @message = "Ход переходит дилеру"
    elsif step == 3
      do_open_cards
    end
  end

  def dealer_turn
    if @dealer.get_current_score >= 17 # dealer could miss his turn
      @message = "Дилер пропускает ход"
    elsif @dealer.get_current_score < 17 # dealer could take a new card
      @dealer.hand << @deck.take_card
      @desk
    end
    @message = "Ход переходит игроку"
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

  def do_open_cards
    @open_cards = true
  end
end
