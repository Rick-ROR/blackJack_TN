#!/usr/bin/ruby -w

class Card
  attr_reader :value, :suit, :point

  def initialize(value, suit, point)
    @value = value
    @suit = suit
    @point = point
  end
end

