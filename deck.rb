require_relative 'card'

class Deck
  attr_accessor :cards
  
  def initialize
    @cards = ((2..10).to_a + %w[J D K A]).product(%w[♠ ♥ ♦ ♣]).map { |n, s| Card.new(n, s) }
  end
  
  def give_cards(count)
    sample_cards = cards.sample(count)
    sample_cards.each { |sc| cards.delete(sc) }
    sample_cards
  end
end
