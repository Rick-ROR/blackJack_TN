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
    # почему это не работает?
    # card_values = @cards..inject([]) { |sum, card | sum << card.point }
    # card_values = @cards.reduce(0) { |sum, card | sum << card.point }
    card_values = []
    @cards.each { |card | card_values << card.point }
    points = card_values.reduce(0, :+)
    return points - 10 if card_values.include?(11) && points > 21
    points
  end
end
