#!/usr/bin/ruby -w

class Player
  attr_reader :bank, :cards, :name

  def initialize(name, money)
    @bank = money
    @name = name
    @cards = {}
    @states = []
  end

  def get_card(card)
    @cards[card[0]] = card[1]
  end

  def put_bet(money)
    @bank -= money
    money
  end

  def get_bank(money)
    @bank += money
  end

  def bankrupt?
    if @bank.zero?
      true
    else
      false
    end
  end

  def return_cards
    @cards = {}
  end

  def scoring
    points = @cards.values.inject(:+)
    if @cards.values.include?(11)
      points_ace = points - 11 + 1
      if points <= 21 && points_ace > 21
        points
      elsif (21 - points_ace) > (21 - points)
        points_ace
      else
        points
      end
    else
      points
    end
  end
end

class Croupier < Player
  def choice
    if @cards.size < 3 && scoring < 17
      :card
    else
      :skip
    end
  end
end
