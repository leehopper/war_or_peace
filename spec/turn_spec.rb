require 'rspec'
require './lib/card'
require './lib/deck'
require './lib/player'
require './lib/turn'

describe Turn do
  before(:each) do
  @card1 = Card.new(:heart, 'Jack', 11)
  @card2 = Card.new(:heart, '10', 10)
  @card3 = Card.new(:heart, '9', 9)
  @card4 = Card.new(:diamond, 'Jack', 11)
  @card5 = Card.new(:heart, '8', 8)
  @card6 = Card.new(:diamond, 'Queen', 12)
  @card7 = Card.new(:heart, '3', 3)
  @card8 = Card.new(:diamond, '2', 2)
  @deck1 = Deck.new([@card1, @card2, @card5, @card8])
  @deck2 = Deck.new([@card3, @card4, @card6, @card7])
  @player1 = Player.new("Megan", @deck1)
  @player2 = Player.new("Aurora", @deck2)
  @turn = Turn.new(@player1, @player2)
  end

  context 'Attribues' do
    it 'is a turn with assigned instance variables' do
      expect(@turn).to be_an_instance_of(Turn)
      expect(@turn.player1).to eq(@player1)
      expect(@turn.player2).to eq(@player2)
      expect(@turn.spoils_of_war).to eq([])
    end
  end

  context 'returns turn types' do
    it 'returns type of turn :basic' do
      expect(@turn.type).to eq(:basic)
    end

    it 'returns type of turn :war' do
      @deck2 = Deck.new([@card1, @card4, @card6, @card7])
      @player2 = Player.new("Aurora", @deck2)
      @turn = Turn.new(@player1, @player2)
      expect(@turn.type).to eq(:war)
    end

    it 'returns type of turn :mutually_assured_destruction' do
      @deck2 = Deck.new([@card1, @card4, @card5, @card7])
      @player2 = Player.new("Aurora", @deck2)
      @turn = Turn.new(@player1, @player2)
      expect(@turn.type).to eq(:mutually_assured_destruction)
    end
  end

  context 'returns winner for all turn types' do
    it 'return :basic type winner' do
      expect(@turn.winner).to eq(@player1)
    end

    it 'return :war type winner' do
      @deck2 = Deck.new([@card1, @card4, @card6, @card7])
      @player2 = Player.new("Aurora", @deck2)
      @turn = Turn.new(@player1, @player2)
      expect(@turn.winner).to eq(@player2)
    end

    it 'return :mutually_assured_destruction type winner' do
      @deck2 = Deck.new([@card1, @card4, @card5, @card7])
      @player2 = Player.new("Aurora", @deck2)
      @turn = Turn.new(@player1, @player2)
      expect(@turn.winner).to eq('No Winner')
    end
  end

  context 'CHANGE' do
    it 'add cards to spoils for :basic turn' do
      @turn.pile_cards
      expect(@turn.spoils_of_war).to eq([@card1, @card3])
    end

    it 'add cards to spoils for :war turn' do
      @deck2 = Deck.new([@card1, @card4, @card6, @card7])
      @player2 = Player.new("Aurora", @deck2)
      @turn = Turn.new(@player1, @player2)

      @turn.pile_cards
      expect(@turn.spoils_of_war).to eq([@card1, @card1, @card2, @card4, @card5, @card6])
      expect(@deck1.cards).to eq([@card8])
      expect(@deck2.cards).to eq([@card7])
    end

    it 'add remove cards for :mutually_assured_destruction' do
      @deck2 = Deck.new([@card1, @card4, @card5, @card7])
      @player2 = Player.new("Aurora", @deck2)
      @turn = Turn.new(@player1, @player2)

      @turn.pile_cards

      expect(@deck1.cards).to eq([@card8])
      expect(@deck2.cards).to eq([@card7])
      expect(@turn.spoils_of_war).to eq([])
    end
  end
end
#
#   context 'award_spoils method' do
#     it 'awards spoils to the winner' do
#       turn.award_spoils
#       expect(player1.deck.cards).to eq([card2, card5, card8, card1, card3])
#       expect(turn.spoils_of_war).to eq([])
#     end
#   end
# end
