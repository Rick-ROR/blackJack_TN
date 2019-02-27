#!/usr/bin/ruby -w

class Deck
  DECK = (2..10).to_a | %w{Jack Queen King ACE}
  SUITS = %w{♤ ♡ ♢ ♧}
  POINTS = Hash[DECK.zip (2..10).to_a + [10, 10, 10, 11]]

  def initialize
    @used_cards = []
  end

  def get_card
    loop do
      value = DECK.sample
      card = "[#{value} #{SUITS.sample}]"
      if @used_cards.size == DECK.size * 4
        raise "Колода пуста!"
      elsif @used_cards.include?(card)
        next
      else
        @used_cards.push(card)
        break [card, POINTS[value]]
      end
    end
  end
end
