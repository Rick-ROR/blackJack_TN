#!/usr/bin/ruby -w
# require_relative 'validation'
class Interface
  include Validation

  # ========================== методы для Casino ================================

  def player_greeting
    puts "\nПриятель, рад видеть тебя на просторах нашего казино!\n\n"
    loop do
      print "Представьтесь, пожалуйста:\t"
      input = gets.chomp
      next unless valid?(input, :regex)
      break input
    end
  end

  def msg_rounds
    puts 'Игроки имеют по три карты и открываются!'
  end

  def msg_balance(player)
    puts "Ваш баланс составляет #{player.bank}$.\n\n"
  end

  def msg_bankrupt(player)
    if player.is_a?(Player)
      puts "Упс, похоже у вас закончились деньги. Мы неплохо провели время, приходите к нам ещё!\n\n"
    else
      puts "Вы отличный игрок и у #{player.name} не осталось больше денег! Заходите к нам попозже!\n\n"
    end
  end


  def next_game?
    loop do
      print "\nПриятель, начнём игру? Д/Н:\t"
      input = gets.chomp
      next unless valid?(input, :regex)
      if input =~ /Да|Д|Yes|Y/i
        puts
        break true
      elsif input =~ /Н(ет)?|N(o)?/i
        puts "\nНичего, загляни к нам как будет время!\n"
        break false
      else
        puts "Я тебя не понимаю!"
      end
    end
  end

  def gen_menu_choice(player, round)
    hash_menu = {:skip => "Пропустить",
                 :open => "Открыть карты",
                 :card => "Добрать карту из колоды",}
    menu = if (round == 1) || (round == 2 && player.cards.size < 3)
             hash_menu.values
           elsif round == 2
             [hash_menu[:skip], hash_menu[:open]]
           else
             [hash_menu[:open]]
           end
    menu.each_with_index { |line, i|  puts "#{i}. #{line}" }
    user = nil
    loop do
      print "\nВаш выбор:\t"
      input = gets.chomp
      next unless valid?(input, :regex, /[0-9]/)
      user = menu[input.to_i]
      if user.nil?
        puts 'Такого элемента нет в меню!'
        next
      else
        break
      end
    end
    puts '-' * 107
    hash_menu.key(user)
  end

  # ========================== методы для LooTable ================================

  def msg_table_skip(player)
    puts "#{player.name} пропускает ход."
  end

  def msg_table_put_bank(player, bet)
    puts "#{player.name} делает ставку #{bet}$."
  end

  def msg_table_get_bank(player, winnings)
    puts "#{player.name} забирает выигрыш в размере #{winnings}$."
  end

  def msg_table_get_card(player)
    puts "#{player.name} добирает карту."
  end

  def msg_table_open(player)
    puts "#{player.name} решил открыть карты!"
  end

  def msg_table_crediting(winner, player)
    if winner.nil?
      puts "Ничья! #{player.name}, похоже ты нашёл равного себе соперника!\n\n"
    else
      puts "Побежадет #{winner.name}!\n\n"
    end
  end

  def msg_table_ending
    puts "\nКонец партии!\n\n"
  end

  def msg_table_status(args = {})
    player = args[:player]
    croupier = args[:croupier]
    bank = args[:bank] || 0
    open = args[:open]
    player_stats, croupier_stats = [], []
    player.cards.each { |card| player_stats << "[#{card.value} #{card.suit}] <= #{card.point}" }
    if open
      croupier.cards.each { |card| croupier_stats << "[#{card.value} #{card.suit}] <= #{card.point}" }
    else
      croupier_stats = Array.new(croupier.cards.size){ "[**] <= X" }
    end
    bank = "#{bank}$".center(5)

    msg_table_status_print(player: player,
                           croupier: croupier,
                           bank: bank,
                           player_stats: player_stats,
                           croupier_stats: croupier_stats)
  end

  def msg_table_status_print(args = {})
    print "\n" + '-' * 107 + "\n"
    print "| %3s$ | %-33s" % [args[:player].bank, args[:player].name]
    print "<%5s ( %4s ) %5s>" % ['=' * 5, args[:bank], '=' * 5]
    print "%33s | %3d$ |" % [args[:croupier].name, args[:croupier].bank]
    print "\n"

    print "%-47s" % [args[:player_stats].join(', ')]
    print " <%5s%5s>" % ['=' * 5, '=' * 5]
    print "%47s " % [args[:croupier_stats].join(', ')]
    print "\n"
    print '-' * 107 + "\n\n"
  end
end
