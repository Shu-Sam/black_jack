require_relative 'deck'
require_relative 'card'
require_relative 'user'
require_relative 'dealer'
require_relative 'gambler'

class Board
  attr_reader :result
  DEAD_HEAT = '---НИЧЬЯ---'
  WIN = '---ВЫ ВЫИГРАЛИ---'
  LOSING = '---ВЫ ПРОИГРАЛИ---'
  TWENTY_ONE = 21
  
  def initialize(params = {})
    @user = User.new(params[:name])
    @deck = Deck.new
    @dealer = Dealer.new('dealer')
    @bank = 0
  end
  
  def start
    @bank = 0
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
  
  def show_user
    user.to_s
  end

  def show_dealer
    dealer.to_s
  end
  
  def take_user_card
    take_card(user)
    dealer_move
  end
  
  private
  
  attr_reader :user, :deck, :dealer, :bank
  attr_writer :bank

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
      puts user.summary_information
      user.discard_cards
    end
    @result = WIN
  end

  def you_lose
    dealer.take_bet(bank)
    do_users do |user|
      puts user.summary_information
      user.discard_cards
    end
    @result = LOSING
  end

  def dead_heat
    user.take_bet(Gambler::BET)
    dealer.take_bet(Gambler::BET)
    do_users do |user|
      puts user.summary_information
      user.discard_cards
    end
    @result = DEAD_HEAT
  end
end
