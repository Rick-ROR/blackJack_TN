#!/usr/bin/ruby -w

class Interface

  # ========================== универсальный метод ================================

  MSGS = {
    msg_greeting: "\nПриятель, рад видеть тебя на просторах нашего казино!\n\n",
    msg_leaving: "\nПриятель, рад видеть тебя на просторах нашего казино!\n\n",
    msg_dont_understand: "Я тебя не понимаю!",
    msg_open_3cards: "\nИгроки имеют по три карты и открываются!",
    msg_open_3round: "\n3-ий ход - открываемся!",
    msg_menu_404: 'Такого элемента нет в меню!',
    msg_balance: "Ваш баланс составляет %s.\n\n",
    msg_bankrupt_plr: "Упс, похоже у вас закончились деньги. Мы неплохо провели время, приходите к нам ещё!\n\n",
    msg_bankrupt_crp: "Вы отличный игрок и у %s не осталось больше денег! Заходите к нам попозже!\n\n",
    msg_table_skip: "%s пропускает ход.",
    msg_table_put_bank: "%s делает ставку %s$.",
    msg_table_get_bank: "%s забирает выигрыш в размере %s$.",
    msg_table_get_card: "%s добирает карту.",
    msg_table_open: "%s решил открыть карты!",
    msg_table_draw: "Ничья! %s, похоже ты нашёл равного себе соперника!\n\n",
    msg_table_crediting: "Побежадет %s!\n\n",
    msg_table_ending: "\nКонец партии!\n\n",
    msg_separate: "\n" + '-' * 107 + "\n\n",
    msg_space: ""
  }

  def msg_print(symbol_msg, *subs)
    subs.map!(&:to_s)
    puts MSGS[symbol_msg] % subs
  end

  # ========================== методы для Casino ================================

  def player_greeting
      print "Представьтесь, пожалуйста:\t"
      gets.chomp
  end

  def next_game
    print "Приятель, начнём игру? Д/Н:\t"
    gets.chomp
  end

  def gen_menu(menu)
    menu.each_with_index { |line, i|  puts "#{i}. #{line}" }
  end

  def gen_menu_gets
    print "\nВаш выбор:\t"
    gets.chomp
  end

  # ========================== методы для LooTable ================================

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
