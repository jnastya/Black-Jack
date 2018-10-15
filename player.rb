class Player

  attr_accessor :money, :hand, :bid
  attr_reader :name

  def initialize(name)
    @name = name
    @money = 100
    @hand = []


  end
end
