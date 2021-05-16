require './lib/player'
require './lib/deck'

class Turn
  attr_reader :player1, :player2, :spoils_of_war

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @spoils_of_war = []
  end

  def type
    if @player1.deck.rank_of_card_at(0) != @player2.deck.rank_of_card_at(0)
      :basic
    elsif @player1.deck.rank_of_card_at(2) != @player2.deck.rank_of_card_at(2)
      :war
    elsif @player1.deck.rank_of_card_at(2) == @player2.deck.rank_of_card_at(2)
      :mutually_assured_destruction
    end
  end

  def winner
    if self.type == :basic
      win = @player1.deck.rank_of_card_at(0) > @player2.deck.rank_of_card_at(0)
    elsif self.type == :war
      win = @player1.deck.rank_of_card_at(2) > @player2.deck.rank_of_card_at(2)
    else self.type == :mutually_assured_destruction
      win = nil
    end

    if win == true
      @player1
    elsif win == false
      @player2
    else
      'No Winner'
    end
  end

  def pile_cards
    if self.type == :basic
      @spoils_of_war << @player1.deck.remove_card
      @spoils_of_war << @player2.deck.remove_card
    elsif self.type == :war
      3.times do
      @spoils_of_war << @player1.deck.remove_card
      @spoils_of_war << @player2.deck.remove_card
      end
    elsif self.type == :mutually_assured_destruction
      3.times do
      @player1.deck.remove_card
      @player2.deck.remove_card
      end
    end
  end

  def award_spoils(winner)
    if winner == @player1
      @spoils_of_war.each do |spoil|
        @player1.deck.add_card(spoil)
      end
    elsif winner == @player2
      @spoils_of_war.each do |spoil|
        @player2.deck.add_card(spoil)
      end
    end
    @spoils_of_war = []
  end

  def special_war
    if @player1.deck.cards.length == 2 || @player2.deck.cards.length == 2
      if @player1.deck.rank_of_card_at(1) == @player2.deck.rank_of_card_at(1)
        2.times do
        @player1.deck.remove_card
        @player2.deck.remove_card
        end
      else
        win = @player1.deck.rank_of_card_at(1) > @player2.deck.rank_of_card_at(1)
        2.times do
          @spoils_of_war << @player1.deck.remove_card
          @spoils_of_war << @player2.deck.remove_card
        end
        if win == true
          self.award_spoils(@player1)
        elsif win == false
          self.award_spoils(@player2)
        elsif win == nil
          @spoils_of_war = []
        end
      end
    elsif @player1.deck.cards.length == 1 || @player2.deck.cards.length == 1
      @player1.deck.remove_card
      @player2.deck.remove_card
    end
  end

  def game_runner
    @turn_num = 0
    while @player1.has_lost? == false && @player2.has_lost? == false
      @turn_num += 1
      if self.type != :basic && @turn_num <= 1000000
        self.special_war
      end
      if self.type == :basic && @turn_num <= 1000000
        puts "Turn #{@turn_num}: #{self.winner.name} won 2 cards"
      elsif self.type == :war && @turn_num <= 1000000
        puts "Turn #{@turn_num}: WAR - #{self.winner.name} won 6 cards"
      elsif self.type == :mutually_assured_destruction && @turn_num <= 1000000
        print "Turn #{@turn_num}: *mutually assured "
        puts 'destruction* 6 cards removed from play'
      elsif @turn_num > 1000000
        puts '*~*~*~* DRAW *~*~*~*'
        puts "#{@player1.name} and #{@player2.name} end their war with peace"
        break
      end
      win = self.winner
      self.pile_cards
      self.award_spoils(win)
    end
  end

  def start
    print 'Welcome to War! (or Peace) '
    puts 'This game will be played with 52 cards.'
    puts "The players today are #{@player1.name} and #{@player2.name}."
    puts 'Type \'GO\' to start the game!'
    puts '-' * 65
    starter = gets.chomp
    if starter == 'GO' || starter == 'go' || starter == 'Go'
      self.game_runner
      if @player1.has_lost? == true && @turn_num < 1000000
        puts "*~*~*~* #{@player2.name} has won the game! *~*~*~*"
      elsif @player2.has_lost? == true && @turn_num < 1000000
        puts "*~*~*~* #{@player1.name} has won the game! *~*~*~*"
      end
    else
      puts 'Invalid input'
    end
  end
end
