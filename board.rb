require_relative 'deck'
require_relative 'card'
require_relative 'user'
require_relative 'dealer'
require_relative 'gambler'

class Board
  attr_reader :result, :data_to_show

  DEAD_HEAT = '---НИЧЬЯ---'.freeze
  WIN = '---ВЫ ВЫИГРАЛИ---'.freeze
  LOSING = '---ВЫ ПРОИГРАЛИ---'.freeze
  TWENTY_ONE = 21.freeze
  PLAY_GAME = 1.freeze
  EXIT = 0.freeze

  SKIP_MOVE = 1.freeze
  TAKE_CARD = 2.freeze
  OPEN_CARDS = 0.freeze

  START_MENU = [
    'Выберите пункт меню',
    '1. Сыграть игру',
    '0. Выход'
  ].freeze

  GAME_MENU = [
    '*****Выберите пункт меню*****',
    '1. Пропустить ход',
    '2. Взять карту',
    '0. Открыть карты'
  ].freeze

  def initialize(params = {})
    @user = User.new(params[:name])
    @deck = Deck.new
    @dealer = Dealer.new('dealer')
    @bank = 0
    @data_to_show = []
  end

  def do_first_action
    loop do
      add_data_to_show(START_MENU)

      index = yield
      case index
      when PLAY_GAME
        play_game do |&block|
          yield block
        end
      when EXIT
        break
      end
    end
  end

  def clear_data_to_show
    @data_to_show = []
  end

  private
  
  attr_reader :user, :deck, :dealer, :bank
  attr_writer :bank

  def play_game
    start
    add_data_to_show('Игра началась')
    private_gamers_info

    game_menu do |&block|
      add_data_to_show(GAME_MENU)

      yield block
    end
  end

  def game_menu
    loop do
      index = yield

      case index
        when SKIP_MOVE
          skip_move

          add_data_to_show('Вы пропустили ход')
          add_data_to_show(dealer.to_s)
        when TAKE_CARD
          take_user_card

          add_data_to_show('Карты вскрыты. Результат раздачи:')
          public_gamers_info

          summarizing

          add_data_to_show(result)
          break
        when OPEN_CARDS
          add_data_to_show('Карты вскрыты. Результат раздачи:')
          public_gamers_info

          summarizing

          add_data_to_show(result)
          break
      end
    end
  end

  def start
    @bank = 0
    [user, dealer].each do |player|
      cards = deck.give_cards(2)
      player.take_cards(cards)
      @bank += player.place_bet(Gambler::BET)
    end
  end

  def skip_move
    dealer_move
  end

  def take_user_card
    take_card(user)
    dealer_move
  end

  def private_gamers_info
    add_data_to_show(user.to_s)
    add_data_to_show(dealer.to_s)
  end

  def public_gamers_info
    add_data_to_show(user.summary_information)
    add_data_to_show(dealer.summary_information)
  end

  def add_data_to_show(str)
    data_to_show << str
  end

  def take_card(gambler)
    cards = deck.give_cards(1)
    gambler.take_cards(cards)
  end
  
  def do_users
    [user, dealer].each { |user| yield user }
  end
  
  def summarizing
    if user.points <= TWENTY_ONE && dealer.points <= TWENTY_ONE
      if user.points > dealer.points
        you_won
      elsif user.points < dealer.points
        you_lose
      else
        dead_heat
      end
    elsif user.points > TWENTY_ONE
      if dealer.points <= TWENTY_ONE
        you_lose
      else
        dead_heat
      end
    elsif dealer.points > TWENTY_ONE
      if user.points <= TWENTY_ONE
        you_won
      else
        dead_heat
      end
    end
  end

  def dealer_move
    take_card(dealer) if dealer.points < 17
  end
  
  def you_won
    user.take_bet(bank)
    do_users do |user|
      user.discard_cards
    end
    @result = WIN
  end

  def you_lose
    dealer.take_bet(bank)
    do_users do |user|
      user.discard_cards
    end
    @result = LOSING
  end

  def dead_heat
    user.take_bet(Gambler::BET)
    dealer.take_bet(Gambler::BET)
    do_users do |user|
      user.discard_cards
    end
    @result = DEAD_HEAT
  end
end
