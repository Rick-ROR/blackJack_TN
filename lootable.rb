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
    @interface.msg_print(:msg_table_skip, player.name)
  end

  def put_bank(player)
    @interface.msg_print(:msg_table_put_bank, player.name, @bet)
    @bank += player.put_bet(@bet)
  end

  def get_bank(*players)
    if players.size == 2
      players.each do |player|
        player.get_bank(@bank/2)
        @interface.msg_print(:msg_table_get_bank, player.name, @bank/2)
      end
    else
      players[0].get_bank(@bank)
      @interface.msg_print(:msg_table_get_bank, players[0].name, @bet)
    end
    @bank = 0
  end

  def card(player)
    player.get_card(@deck.get_card)
    @interface.msg_print(:msg_table_get_card, player.name)
  end

  def open?(round)
    if @player.cards.size == 3 && @croupier.cards.size == 3
      @interface.msg_print(:msg_open_3cards)
      true
    elsif round == 3
      @interface.msg_print(:msg_open_3round)
      true
    else
      false
    end
  end

  def open(player = nil)
    unless player.nil?
      @interface.msg_print(:msg_table_open, player.name)
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
      @interface.msg_print(:msg_table_draw, @player.name)
      get_bank(@player, @croupier)
    else
      @interface.msg_print(:msg_table_crediting, winner.name)
      get_bank(winner)
    end

    [@player, @croupier].each(&:return_cards)
    @interface.msg_print(:msg_table_ending)
    raise
  end

  def status(open = false)
    player_stats, croupier_stats = [], []
    @player.cards.each { |card| player_stats << "[#{card.value} #{card.suit}] <= #{card.point}" }
    if open
      @croupier.cards.each { |card| croupier_stats << "[#{card.value} #{card.suit}] <= #{card.point}" }
    else
      croupier_stats = Array.new(@croupier.cards.size){ "[**] <= X" }
    end
    bank = "#{@bank}$".center(5)

    @interface.msg_table_status_print(player: @player,
                                      croupier: @croupier,
                                      bank: bank,
                                      player_stats: player_stats,
                                      croupier_stats: croupier_stats)
  end
end
