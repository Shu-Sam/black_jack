require_relative 'deck'
require_relative 'card'
require_relative 'user'
require_relative 'dealer'
require_relative 'gambler'

class Board
  attr_reader :result
  
  def initialize(params = {})
    @user = User.new(params[:name])
    @deck = Deck.new
    @dealer = Dealer.new('dealer')
    @bank = 0
  end
  
  def start
    @bank = 0
    @result = { hands: [] }

    [user, dealer].each do |player|
      cards = deck.give_cards(2)
      player.take_cards(cards)
      @bank += player.place_bet(Gambler::BET)
    end
  end
  
  def open_cards
    summarizing
  end
  
  def skip_move
    dealer_move
  end

  def show_dealer
    dealer
  end

  def show_gamers
    [user, dealer]
  end

  def show_result
    [result[:hands], result[:result]]
  end
  
  def take_user_card
    take_card(user)
    dealer_move
  end
  
  private
  
  attr_reader :user, :deck, :dealer, :bank
  attr_writer :bank

  DEAD_HEAT = '---НИЧЬЯ---'.freeze
  WIN = '---ВЫ ВЫИГРАЛИ---'.freeze
  LOSING = '---ВЫ ПРОИГРАЛИ---'.freeze
  TWENTY_ONE = 21.freeze

  def take_card(gambler)
    cards = deck.give_cards(1)
    gambler.take_cards(cards)
  end
  
  def do_users
    [user, dealer].each { |user| yield user }
  end
  
  def summarizing
    result[:result] =
      if user.points <= TWENTY_ONE && dealer.points <= TWENTY_ONE
        if user.points > dealer.points
          you_won
        elsif user.points < dealer.points
          you_lose
        else
          dead_heat
        end
      elsif user.points > TWENTY_ONE
        dealer.points <= TWENTY_ONE ? you_lose : dead_heat
      elsif dealer.points > TWENTY_ONE
        user.points <= TWENTY_ONE ? you_won : dead_heat
      end

    do_users do |user|
      result[:hands] << user.summary_information
      user.discard_cards
    end
  end

  def dealer_move
    take_card(dealer) if dealer.points < 17
  end
  
  def you_won
    user.take_bet(bank)
    WIN
  end

  def you_lose
    dealer.take_bet(bank)
    LOSING
  end

  def dead_heat
    user.take_bet(Gambler::BET)
    dealer.take_bet(Gambler::BET)
    DEAD_HEAT
  end
end
