#!/usr/bin/ruby -w

class Casino
  CROUPIER = 'Bender'
  START_BANK = 100
  BET = 10

  def initialize
    @interface = Interface.new
  end

  def new_player
      name = @interface.player_greeting
      @player = Player.new(name, START_BANK)
      @croupier = Croupier.new(CROUPIER, START_BANK)
  end

  def rounds
    1.upto(3) do |i|
      if @lootable.open?(i)
        @lootable.open
        return
      end
      @lootable.status
      [@player, @croupier].each do |player|
        if player.is_a?(Croupier)
          @lootable.send(player.choice, player)
        else
          choice = @interface.gen_menu_choice(player, i)
          @lootable.send(choice, player)
        end
      end
    end
  end

  def bankrupt
    if @player.bankrupt?
      @interface.msg_print(:msg_bankrupt_plr)
      true
    elsif @croupier.bankrupt?
      @interface.msg_print(:msg_bankrupt_crp, @croupier.name)
      true
    else
      false
    end
  end

  def start_game
    exit unless @interface.next_game?
    @lootable = LooTable.new(@interface, Deck.new, BET, @player, @croupier)
    rounds
  rescue RuntimeError
    @interface.msg_print(:msg_balance, @player.name)
    return if bankrupt
    retry
  end
end
