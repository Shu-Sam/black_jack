class Card
  attr_accessor :num, :suit
  
  def initialize(num, suit)
    @num = num
    @suit = suit
  end
  
  def value
    num.is_a?(Integer) ? num : (ace? ? 11 : 10)
  end
  
  def ace?
    num == 'A'
  end
  
  def to_s
    "#{num}#{suit}"
  end
end
