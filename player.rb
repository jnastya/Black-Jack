class Player

  attr_accessor :money, :hand, :bid
  attr_reader :player_name

  def initialize(player_name)
    @player_name = player_name
    @money = 100
    @hand = []
  end
end
