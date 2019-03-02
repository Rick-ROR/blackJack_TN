#!/usr/bin/ruby -w

class LooTable
  attr_reader :bank

  def initialize(interface, deck, bet, player, croupier)
    @interface = interface
    @deck = deck
    @bank = 0
    @bet = bet
    @player = player
    @croupier = croupier
    start
  end

  def start
    put_bank(@player)
    put_bank(@croupier)
    card(@player)
    card(@croupier)
    card(@player)
    card(@croupier)
  end

  def skip(player)
    @interface.msg_table_skip(player)
  end

  def put_bank(player)
    @interface.msg_table_put_bank(player, @bet)
    @bank += player.put_bet(@bet)
  end

  def get_bank(plrs_array)
    if plrs_array.size == 2
      plrs_array.each do |player|
        player.get_bank(@bank/2)
        @interface.msg_table_get_bank(player, @bank/2)
      end
    else
      plrs_array[0].get_bank(@bank)
      @interface.msg_table_get_bank(plrs_array[0], @bank)
    end
    @bank = 0
  end

  def card(player)
    player.get_card(@deck.get_card)
    @interface.msg_table_get_card(player)
  end

  def open?
    if @player.cards.size == 3 && @croupier.cards.size == 3
      true
    else
      false
    end
  end

  def open(player = nil)
    unless player.nil?
      @interface.msg_table_open(player)
    end
    status(true)
    crediting(winner?)
  end

  def winner?
    player = @player.scoring
    croupier = @croupier.scoring

    if player == croupier
      nil
    elsif (player > 21 && croupier > 21) && (21 - player > 21 - croupier)
      @player
    elsif player > 21 && croupier <= 21
      @croupier
    elsif (player <= 21 && croupier > 21) || 21 - player < 21 - croupier
      @player
    else
      @croupier
    end
  end

  def crediting(winner)
    if winner.nil?
      @interface.msg_table_crediting(winner, @player)
      get_bank([@player, @croupier])
    else
      @interface.msg_table_crediting(winner, @player)
      get_bank([winner])
    end

    [@player, @croupier].each(&:return_cards)
    @interface.msg_table_ending
    raise
  end

  def status(open = false)
    @interface.msg_table_status(open: open,
                                player: @player,
                                croupier: @croupier,
                                bank: @bank)
  end
end
