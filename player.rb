class Player

  attr_accessor :money, :hand, :bid, :can_show_dealer_cards
  attr_reader :player_name

  def initialize(player_name)
    @player_name = player_name
    @money = 100
    @hand = []
    @can_show_dealer_cards = false
  end

  def dealer_cards
    @can_show_dealer_cards ? get_real_cards : '*' * @hand.length
  end

  def player_cards
    get_real_cards
  end

  def get_real_cards
    output = []
    @hand.each do |card|
      output << card.value + card.suit
    end
    output.join(', ')
  end

  def get_current_score
    summ = 0
    ace_storage = []
    @hand.each do |card|
      next ace_storage << card if card.value == 'A'
      summ += card.score
    end
    ace_storage.each do |ace|
      mid_summ = ace.create_score_ace(summ)
      summ += mid_summ
    end
    summ
  end
end
