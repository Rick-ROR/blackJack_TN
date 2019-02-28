#!/usr/bin/ruby -w

class Player
  attr_reader :bank, :cards, :name

  def initialize(name, money)
    @bank = money
    @name = name
    @cards = []
  end

  def get_card(card)
    @cards << card
  end

  def put_bet(money)
    @bank -= money
    money
  end

  def get_bank(money)
    @bank += money
  end

  # есть похожий метод в казино
  def bankrupt?
    @bank.zero?
  end

  def return_cards
    @cards = []
  end

  def scoring
    card_values = @cards.reduce([]) { |sum, card | sum << card.point }
    points = card_values.reduce(:+)
    return points - 10 if card_values.include?(11) && points > 21
    points
  end
end
