class Card

attr_accessor :suit, :value, :score

  def initialize(suit, value)
    @suit = suit
    @value = value
    @score = 0
    create_score
    validate!
  end

  def create_score
    if @value =~ /10|[JQK]/
      @score = 10
    elsif @value =~ /[2-9]/
      @score = @value.to_i
    end
  end

  def create_score_ace(summ)
    summ < 11 ? 11 : 1
  end

  def valid?
    validate!
  rescue
    false
  end

  protected

  def validate!
    raise RegexpError, 'Suits are not suitable' if @suit !~ /[♣️♥️♠️♦️]/
    raise RegexpError, 'Values are not suitable' if @value !~ /[2-9]|10|[JQKA]/
    true
  end
end
