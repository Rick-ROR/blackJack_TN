#!/usr/bin/ruby -w

class Deck
  DECK = (2..10).to_a | %w{Jack Queen King ACE}
  SUITS = %w{♠ ♥ ♦ ♣}
  POINTS = Hash[DECK.zip (2..10).to_a + [10, 10, 10, 11]]

  def initialize
    @cards = []
    make_deck
  end

  def make_deck
    SUITS.each do |suit|
      DECK.each do |value|
        @cards << Card.new(value, suit, POINTS[value])
      end
    end
  end

  def get_card
    raise "Колода пуста!" if @cards.empty?
    @cards.delete(@cards.sample)
  end
end
