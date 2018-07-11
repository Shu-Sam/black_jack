require_relative 'card'

class Scoring
  
  def self.scoring(cards)
    
    aces = cards.select(&:ace?)
    no_aces_cards = cards - aces
    points = no_aces_cards.map(&:value).sum
    
    prev_point = nil
    aces.each do |ace|
      sum = points + ace.value
      
      ace_point = sum > 21 ? 1 : ace.value
      points += ace_point
      if (points + ace_point > 21) && prev_point == 11
        points -= 10
      end
      prev_point = ace_point
    end
    
    points
  end
end
