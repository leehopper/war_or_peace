require './lib/card'

class Deck
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def rank_of_cards_at(index)
    @cards.at(index).rank 
  end

end
