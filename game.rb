require_relative 'player'

class Game

  attr_accessor :player, :dealer, :bank
  attr_reader :cards, :status

  def initialize
    @cards = [
      {"2♣️" => 2}, {"3♣️" => 3}, {"4♣️" => 4}, {"5♣️" => 5}, {"6♣️" => 6}, {"7♣️" => 7}, {"8♣️" => 8}, {"9♣️" => 9}, {"10♣️" => 10}, {"J♣️" => 10}, {"Q♣️" => 10}, {"K♣️" => 10}, {"A♣️" => 1},
      {"2♥️" => 2}, {"3♥️" => 3}, {"4♥️" => 4}, {"5♥️" => 5}, {"6♥️" => 6}, {"7♥️" => 7}, {"8♥️" => 8}, {"9♥️" => 9}, {"10♥️" => 10}, {"J♥️" => 10}, {"Q♥️" => 10}, {"K♥️" => 10}, {"A♥️" => 1},
      {"2♠️" => 2}, {"3♠️" => 3}, {"4♠️" => 4}, {"5♠️" => 5}, {"6♠️" => 6}, {"7♠️" => 7}, {"8♠️" => 8}, {"9♠️" => 9}, {"10♠️" => 10}, {"J♠️" => 10}, {"Q♠️" => 10}, {"K♠️" => 10}, {"A♠️" => 1},
      {"2♦️" => 2}, {"3♦️" => 3}, {"4♦️" => 4}, {"5♦️" => 5}, {"6♦️" => 6}, {"7♦️" => 7}, {"8♦️" => 8}, {"9♦️" => 9}, {"10♦️" => 10}, {"J♦️" => 10}, {"Q♦️" => 10}, {"K♦️" => 10}, {"A♦️" => 1},
    ]
    @bid = 10
    @bank = 0
    @status = 0
  end

  def hide_dealer_cards(dealer_cards)
    return '*' * dealer_cards.length
  end

  def show_real_cards(cards)
    output = []
    cards.each do |card|
      output << card.keys[0]
    end
    output.join(', ')
  end

  def show_current_score(cards)
    summ = 0
    ace = false
    cards.each do |card|
      if card.has_key?("A♣️") || card.has_key?("A♥️") || card.has_key?("A♠️") || card.has_key?("A♦️")
        ace = true
      else
        summ += card.values[0]
      end
    end
    if ace && summ < 11
      summ += 11
    elsif ace
      summ += 1
    end
    summ
  end

  def desk
    puts "_______________________________________"
    puts "| Карты дилера: #{@status == 0 ? hide_dealer_cards(@dealer.hand) : show_real_cards(@dealer.hand)}                    |"
    puts "| Деньги дилера: #{@dealer.money}$             |"
    if @status != 0
      puts "| Очки дилера: #{show_current_score(@dealer.hand)}                      |"
    end
    puts "|                                     |"
    puts "|                                     |"
    if @status == 0
      puts "| Ставка: #{@bank}                          |"
    elsif @status == 1
      puts "|          Вы выиграли!               |"
    elsif @status == 2
      puts "|                Ничья!               |"
    elsif @status == 3
      puts "| Вы проиграли, попробуйте еще раз!   |"
    end
    puts "|                                     |"
    puts "|                                     |"
    puts "| Ваши карты: #{show_real_cards(@player.hand)}                  |"
    puts "| Ваши очки: #{show_current_score(@player.hand)}                       |"
    puts "| Ваши деньги: #{@player.money}$                    |"
    puts "|_____________________________________|"
  end

  # Statuses:
  # 1 - Player win
  # 2 - Draw
  # 3 - Dealer win
  # 4 - Finish game

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

  def game
    @player.hand = @cards.shift(2)
    @dealer.hand = @cards.shift(2)
    @bank = @bid * 2
    @player.money -= @bid
    @dealer.money -= @bid
    desk
    while @player.hand.length < 3 && @dealer.hand.length < 3 do
      player_turn
      break if @status == 4
      dealer_turn
    end
    results
    desk
  end

  def player_turn
    puts "Выбирете вариант:"
    puts "1. Пропустить ход"
    puts "2. Добавить карту"
    puts "3. Открыть карты"
    step = gets.to_i
    if step == 1
      puts "Ход переходит дилеру"
    elsif step == 2
      if @player.hand.length < 3
        card = @cards.shift(1)
        @player.hand << card[0] # new card for player
        desk # update ui
      else
        puts "Число карт игрока превышено"
      end
      puts "Ход переходит дилеру"
    elsif step == 3
      @status = 4
    end
  end

  def dealer_turn
    if show_current_score(@dealer.hand) >= 17 # dealer could miss his turn
      puts "Дилер пропускает ход"
    elsif show_current_score(@dealer.hand) < 17 # dealer could take a new card
      card = @cards.shift(1)
      @dealer.hand << card[0]
      desk
    end
    puts "Ход переходит игроку"
  end

  def menu
    puts "Введите Ваше имя"
    name = gets.chomp
    @player = Player.new(name)
    @dealer = Player.new('Dealer')
    loop do
      @cards.shuffle!
      game
      puts "Повторить (y/n)?"
      choise = gets.chomp
      break if choise == "n" || @player.money == 0 || @dealer.money == 0
      puts "#{@cards}"
      @status = 0
      @bank = 0
      # refresh cards
      @cards = [
        {"2♣️" => 2}, {"3♣️" => 3}, {"4♣️" => 4}, {"5♣️" => 5}, {"6♣️" => 6}, {"7♣️" => 7}, {"8♣️" => 8}, {"9♣️" => 9}, {"10♣️" => 10}, {"J♣️" => 10}, {"Q♣️" => 10}, {"K♣️" => 10}, {"A♣️" => 1},
        {"2♥️" => 2}, {"3♥️" => 3}, {"4♥️" => 4}, {"5♥️" => 5}, {"6♥️" => 6}, {"7♥️" => 7}, {"8♥️" => 8}, {"9♥️" => 9}, {"10♥️" => 10}, {"J♥️" => 10}, {"Q♥️" => 10}, {"K♥️" => 10}, {"A♥️" => 1},
        {"2♠️" => 2}, {"3♠️" => 3}, {"4♠️" => 4}, {"5♠️" => 5}, {"6♠️" => 6}, {"7♠️" => 7}, {"8♠️" => 8}, {"9♠️" => 9}, {"10♠️" => 10}, {"J♠️" => 10}, {"Q♠️" => 10}, {"K♠️" => 10}, {"A♠️" => 1},
        {"2♦️" => 2}, {"3♦️" => 3}, {"4♦️" => 4}, {"5♦️" => 5}, {"6♦️" => 6}, {"7♦️" => 7}, {"8♦️" => 8}, {"9♦️" => 9}, {"10♦️" => 10}, {"J♦️" => 10}, {"Q♦️" => 10}, {"K♦️" => 10}, {"A♦️" => 1},
      ]
    end
  end
end
