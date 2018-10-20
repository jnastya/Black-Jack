require_relative 'deck'
class Game

  attr_accessor :player, :dealer, :bank
  attr_reader :status, :deck

  def initialize(player_name)
    @bid = 10
    @bank = 0
    @deck = Deck.new
    @cards = @deck.shuffle_cards
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

  def take_card(player)
    card = @cards.shift(1)
    player.hand << card[0]
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
      @player.money += @bid
      @dealer.money += @bid
      @status = 2
    end
  end

  def start_game
    @deck.create_score
    @status = 0
    @bank = 0
    #@deck.shuffle_cards
    @player.hand = @cards.shift(2)
    @dealer.hand = @cards.shift(2)
    @bank = @bid * 2
    @player.money -= @bid
    @dealer.money -= @bid
  end

  def reset_deck
    @deck = Deck.new
    @cards = @deck.shuffle_cards
  end
end
