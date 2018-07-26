class Strategy
  EXIT = 0.freeze
  PLAY_GAME = 1.freeze
  SKIP_MOVE = 2.freeze
  TAKE_CARD = 3.freeze
  OPEN_CARDS = 4.freeze

  START_MENU = [
    'Выберите пункт меню',
    '1. Сыграть игру',
    '0. Выход'
  ]

  GAME_MENU = [
    '*****Выберите пункт меню*****',
    '2. Пропустить ход',
    '3. Взять карту',
    '4. Открыть карты',
  ]

  def self.do_action(action_id, board)
    result = []

    case action_id
    when PLAY_GAME
      result << 'Игра началась'
      board.start
      result << board.show_gamers
    when SKIP_MOVE
      result << 'Вы пропустили ход'
      board.skip_move
      result << board.show_dealer
    when TAKE_CARD
      board.take_user_card
      result << board.show_gamers
    when OPEN_CARDS
      result << '__________________________________'
      result << 'Карты вскрыты. Результат раздачи:'
      board.open_cards
      result << board.show_result
      result << '__________________________________'
    end

    result
  end
end
