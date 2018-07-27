require_relative 'board'
require_relative 'strategy'

class Interface
  attr_reader :board

  def runner
    puts 'Введите имя пользователя:'
    name = gets.chomp
    @board = Board.new(name: name)

    loop do
      puts Strategy::START_MENU
  
      index = read_action
      break if index == Strategy::EXIT

      do_and_print_action(Strategy::PLAY_GAME)

      loop do
        puts Strategy::GAME_MENU
        index = read_action
        do_and_print_action(index)

        break if index != Strategy::SKIP_MOVE
      end
      
      do_and_print_action(Strategy::OPEN_CARDS) unless index == Strategy::OPEN_CARDS
    end
  end

  private

  def read_action
    gets.chomp.to_i
  end

  def do_and_print_action(action)
    result = Strategy.do_action(action, board)
    puts result
  end
end
