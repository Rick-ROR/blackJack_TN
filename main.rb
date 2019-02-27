#!/usr/bin/ruby -w
require_relative 'lootable'
require_relative 'deck'
require_relative 'players'
require_relative 'validation'

trap 'SIGINT' do
  puts 'Ctrl+C => Exiting'
  exit
end

class Casino
  include Validation
  CROUPIER = 'Bender'
  START_BANK = 20
  BET = 10

  def greeting
    puts "\nПриятель, рад видеть тебя на просторах нашего казино!\n\n"
  end

  def next_game
    puts "Оо, знакомые лица!"
  end

  def new_player
    loop do
      print "Представьтесь, пожалуйста:\t"
      input = gets.chomp
      next unless valid?(input, :regex)
      @players = [Player.new(input, START_BANK), Croupier.new(CROUPIER, START_BANK)]
      break
    end
  end

  def bankrupt?(player)
    if player.bank.zero?
      raise "Упс, похоже у вас закончились деньги. Мы неплохо провели время, приходите к нам ещё!"
    end
  end

  def rounds
    1.upto(3) do |i|
      if @lootable.open?
        puts 'Игроки имеют по три карты и открываются!'
        @lootable.open
        return
      end
      @lootable.status
      @players.each do |player|
        if player.is_a?(Croupier)
          @lootable.send(player.choice, player)
        else
          choice = gen_menu_choice(player, i)
          @lootable.send(choice, player)
        end
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

  def bankrupt
    if @players[0].bankrupt?
      puts "Упс, похоже у вас закончились деньги. Мы неплохо провели время, приходите к нам ещё!\n\n"
      true
    elsif @players[1].bankrupt?
      puts "Вы отличный игрок и у #{@players[1].name} не осталось больше денег! Заходите к нам попозже!\n\n"
      true
    else
      false
    end
  end

  def next_game?
    loop do
      print "\nПриятель, начнём игру? Д/Н:\t"
      input = gets.chomp
      next unless valid?(input, :regex)
      if input =~ /Да|Д|Yes|Y/i
        break
      elsif input =~ /Н(ет)?|N(o)?/i
        puts "\nНичего, загляни к нам как будет время!"
        exit
      else
        puts "Я тебя не понимаю!"
      end
    end
  end

  def start_game
    next_game?
    @lootable = LooTable.new(Deck.new, BET, *@players)
    rounds
  rescue RuntimeError => e
    puts e.message
    puts "Ваш баланс составляет #{@players[0].bank}$.\n\n"
    return if bankrupt
    retry
  end
end

casino = Casino.new

casino.greeting
casino.new_player
casino.start_game





