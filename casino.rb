#!/usr/bin/ruby -w

class Casino
  include Validation

  CROUPIER = 'Bender'
  START_BANK = 100
  BET = 10

  def initialize
    @interface = Interface.new
  end

  def new_player
    @interface.msg_print(:msg_greeting)
    name = loop do
      name = @interface.player_greeting
      next unless valid?(name, :regex)
      @interface.msg_print(:msg_space)
      break name
    end
    @player = Player.new(name, START_BANK)
    @croupier = Croupier.new(CROUPIER, START_BANK)
  end

  def next_game?
    loop do
      input = @interface.next_game
      next unless valid?(input, :regex)
      if input =~ /Да|Д|Yes|Y/i
        @interface.msg_print(:msg_space)
        break true
      elsif input =~ /Н(ет)?|N(o)?/i
        @interface.msg_print(:msg_leaving)
        break false
      else
        @interface.msg_print(:msg_dont_understand)
      end
    end
  end

  def menu(player, round)
    hash_menu = {:skip => "Пропустить",
                 :open => "Открыть карты",
                 :card => "Добрать карту из колоды",}

    menu = menu_generator(hash_menu, player, round)
    choice = menu_choice(menu)
    hash_menu.key(choice)
  end

  def menu_generator(hash_menu, player, round)
    menu = if (round == 1) || (round == 2 && player.cards.size < 3)
             hash_menu.values
           elsif round == 2
             [hash_menu[:skip], hash_menu[:open]]
           else
             [hash_menu[:open]]
           end
    @interface.gen_menu(menu)
    menu
  end

  def menu_choice(menu)
    loop do
      input = @interface.gen_menu_gets
      next unless valid?(input, :regex, /[0-9]/)
      user_choice = menu[input.to_i]
      if user_choice.nil?
        @interface.msg_print(:msg_menu_404)
        next
      else
        @interface.msg_print(:msg_separate)
        break user_choice
      end
    end
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
          choice = menu(player, i)
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
    exit unless next_game?
    @lootable = LooTable.new(@interface, Deck.new, BET, @player, @croupier)
    rounds
  rescue RuntimeError
    @interface.msg_print(:msg_balance, @player.bank)
    return if bankrupt
    retry
  end
end
