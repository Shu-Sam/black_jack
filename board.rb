require_relative 'deck'
require_relative 'card'
require_relative 'user'
require_relative 'dealer'
require_relative 'gambler'

class Board
  attr_reader :user, :deck, :dealer, :bank
  attr_writer :bank
  
  TWENTY_ONE = 21
  def initialize(params = {})
    @user = User.new(params[:name])
    @deck = Deck.new
    @dealer = Dealer.new('dealer')
    @bank = 0
  end
  
  def start
    self.bank = 0
    [user, dealer].each do |player|
      cards = deck.give_cards(2)
      player.take_cards(cards)
      self.bank += player.place_bet(Gambler::BET)
    end
  end
  
  def take_card(gambler)
    cards = deck.give_cards(1)
    gambler.take_cards(cards)
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
    puts dealer
  end

  private
  
  def do_users
    [user, dealer].each { |user| yield user }
  end

  def you_won
    puts '---ВЫ ВЫИГРАЛИ---'
    user.take_bet(bank)
    do_users do |user|
      puts user.summary_information
      user.discard_cards
    end
  end

  def you_lose
    puts '---ВЫ ПРОИГРАЛИ---'
    dealer.take_bet(bank)
    do_users do |user|
      puts user.summary_information
      user.discard_cards
    end
  end

  def dead_heat
    puts '---НИЧЬЯ---'
    user.take_bet(Gambler::BET)
    dealer.take_bet(Gambler::BET)
    do_users do |user|
      puts user.summary_information
      user.discard_cards
    end
  end
end
