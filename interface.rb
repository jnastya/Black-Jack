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

  def menu
    puts "Введите Ваше имя"
    player_name = gets.chomp
    @game = Game.new(player_name)
    loop do
      @game.start_game
      desk
      puts "Выбирете вариант:"
      puts "1. Пропустить ход"
      puts "2. Добавить карту"
      puts "3. Открыть карты"
      step = gets.to_i
      raise "Invalid input if" if step < 1 || step > 3
      @game.actions(step)
      @game.results
      desk
      puts "Повторить (y/n)?"
      choise = gets.chomp
      break if choise == "n" || @game.player.money == 0 || @game.dealer.money == 0
      @game.reset
    end
  end
end
