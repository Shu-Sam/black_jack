require_relative 'board'

class Interface
  PLAY_GAME = 1
  EXIT = 0

  SKIP_MOVE = 1
  TAKE_CARD = 2
  OPEN_CARDS = 0
  
  attr_reader :board

  def show_start_menu
    puts 'Выберите пункт меню'
    puts '1. Сыграть игру'
    puts '0. Выход'
  end

  def show_game_menu
    puts '*****Выберите пункт меню*****'
    puts '1. Пропустить ход'
    puts '2. Взять карту'
    puts '0. Открыть карты'
  end
  
  def runner
    puts 'Введите имя пользователя'
    name = gets.chomp
    @board = Board.new(name: name)

    loop do
      show_start_menu
  
      index = gets.chomp.to_i
      case index
      when PLAY_GAME then play_game
      when EXIT then break
      end
    end
    
  end

  def open_cards
    puts '__________________________________'
    puts 'Карты вскрыты. Результат раздачи:'
    board.open_cards
    puts board.result
    puts '__________________________________'
  end
  
  def take_card
    board.take_user_card
    # puts board.show_user
    # puts board.show_dealer
  end
  
  def skip_move
    puts 'Вы пропустили ход'
    board.dealer_move
    # puts board.show_dealer
  end
  
  def play_game
    puts 'Игра началась'
    board.start
    # puts board.show_user
    # puts board.show_dealer

    loop do
      show_game_menu
      index = gets.chomp.to_i
      case index
      when SKIP_MOVE then skip_move
      when TAKE_CARD
        take_card
        open_cards
        break
      when OPEN_CARDS
        open_cards
        break
      end
    end
  end
end
