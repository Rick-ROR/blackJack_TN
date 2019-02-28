#!/usr/bin/ruby -w

class Croupier < Player
  def choice
    if @cards.size < 3 && scoring < 17
      :card
    else
      :skip
    end
  end
end
