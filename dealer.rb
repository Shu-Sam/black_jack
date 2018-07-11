require_relative 'gambler'

class Dealer < Gambler
  
  def to_s
    "#{name}: #{" * " * hand.count}; денег: #{cash}"
  end
end
