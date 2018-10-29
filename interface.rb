require_relative 'player'
require_relative 'game'
require_relative 'deck'

class Interface

  attr_reader :status

  def desk
    puts "_______________________________________"
    puts "| Карты дилера: #{@game.dealer.dealer_cards}                    |"
    if @game.status != 0
      puts "| Очки дилера: #{@game.dealer.get_current_score}                      |"
    end
    puts "| Деньги дилера: #{@game.dealer.money}$             |"
    puts "|                                     |"
    puts "|                                     |"
    if @game.status == 0
      puts "| Ставка: #{@game.bank}                          |"
    elsif @game.status == 1
      puts "|          Вы выиграли!               |"
    elsif @game.status == 2
      puts "|                Ничья!               |"
    elsif @game.status == 3
      puts "| Вы проиграли, попробуйте еще раз!   |"
    end
    puts "|                                     |"
    puts "|                                     |"
    puts "| Ваши карты: #{@game.player.player_cards}                  |"
    puts "| Ваши очки: #{@game.player.get_current_score}                       |"
    puts "| Ваши деньги: #{@game.player.money}$                    |"
    puts "|_____________________________________|"
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
      if @game.player.hand.length < 3
        @game.player_take_card
        desk # update ui
      else
        puts "Число карт игрока превышено"
      end
      puts "Ход переходит дилеру"
    elsif step == 3
      @game.do_open_cards
    end
  end

  def dealer_turn
    if @game.dealer.get_current_score >= 17 # dealer could miss his turn
      puts "Дилер пропускает ход"
    elsif @game.dealer.get_current_score < 17 # dealer could take a new card
      @game.dealer_take_card
      desk
    end
    puts "Ход переходит игроку"
  end

  def menu
    puts "Введите Ваше имя"
    player_name = gets.chomp
    @game = Game.new(player_name)
    loop do
      @game.start_game
      desk
      while @game.player.hand.length < 3 && @game.dealer.hand.length < 3 do
        player_turn
        dealer_turn
        break if @game.open_cards
      end
      @game.results
      desk
      puts "Повторить (y/n)?"
      choise = gets.chomp
      break if choise == "n" || @game.player.money == 0 || @game.dealer.money == 0
      @game.reset
    end
  end
end
