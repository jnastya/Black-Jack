require_relative 'deck'
class Game

  attr_accessor :player, :dealer, :bank
  attr_reader :status, :deck

  BID = 10

  def initialize(player_name)
    @bank = 0
    @deck = Deck.new
    @player = Player.new(player_name)
    @dealer = Player.new('Dealer')
  end

  def hide_dealer_cards(dealer_cards)
    return '*' * dealer_cards.length
  end

  def show_real_cards(cards)
    output = []
    cards.each do |card|
      output << card.value + card.suit
    end
    output.join(', ')
  end

  def show_current_score(cards)
    summ = 0
    ace = false
    cards.each do |card|
      if card.value == 'A'
        ace = true
      else
        summ += card.score
      end
    end
    if ace && summ < 11
      summ += 11
    elsif ace
      summ += 1
    end
    summ
  end

  # Statuses:
  # 1 - Player win
  # 2 - Draw
  # 3 - Dealer win

  def results
    if show_current_score(@player.hand) > 21
      @dealer.money += @bank
      @status = 3
    elsif show_current_score(@dealer.hand) > 21
      @player.money += @bank
      @status = 1
    elsif show_current_score(@player.hand) > show_current_score(@dealer.hand)
      @player.money += @bank
      @status = 1
    elsif show_current_score(@player.hand) < show_current_score(@dealer.hand)
      @dealer.money += @bank
      @status = 3
    else show_current_score(@player.hand) == show_current_score(@dealer.hand)
      @player.money += BID
      @dealer.money += BID
      @status = 2
    end
  end

  def start_game
    @deck.create_score
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
    @deck.shuffle_cards
    @player.hand = []
    @dealer.hand = []
  end
end
