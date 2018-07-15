require_relative 'deck'
require_relative 'scoring'
class Gambler
  attr_accessor :name, :cash, :hand, :bet
  CASH = 100.freeze
  BET = 10.freeze
  
  def initialize(name)
    @name = name
    @cash = CASH
    @hand = []
    @bet = BET
  end

  def take_cards(cards)
    self.hand += cards
  end
  
  def points
    Scoring.scoring(hand)
  end
  
  def to_s
    summary_information
  end

  def summary_information
    "#{name}: #{hand.join(' ')}; очков: #{points}; денег: #{cash}"
  end
  
  def place_bet(bet)
    raise 'недостаточно денег' if cash < bet
    
    self.cash -= bet
    bet
  end
  
  def take_bet(bet)
    self.cash += bet
  end

  def discard_cards
    self.hand = []
  end
end
