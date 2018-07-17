require_relative 'board'

class Interface
  attr_reader :board

  def runner
    puts 'Введите имя пользователя'
    name = gets.chomp
    @board = Board.new(name: name)
    board.do_first_action do
      puts '------------------'
      puts board.data_to_show
      board.clear_data_to_show

      gets.chomp.to_i
    end
  end
end
