#!/usr/bin/ruby -w

class LooTable
  attr_reader :bank


  def initialize(deck, bet, player, croupier)
    @deck = deck
    @bank = 0
    @bet = bet
    @players = [player, croupier]
    start
  end

  def start
    @players.each do |player|
      card(player)
      card(player)
      put_bank(player)
      puts
    end
  end

  # def skip(*); end
  def skip(player)
    puts "#{player.name} пропускает ход."
  end

  def put_bank(player)
    puts "#{player.name} делает ставку #{@bet}$."
    @bank += player.put_bet(@bet)
  end

  def get_bank(plrs_array)
    if plrs_array.size == 2
      plrs_array.each do |player|
        player.get_bank(@bank/2)
        puts "#{player.name} забирает выигрыш в размере #{@bank/2}$."
      end
    else
      plrs_array[0].get_bank(@bank)
      puts "#{plrs_array[0].name} забирает выигрыш в размере #{@bank}$."
    end
    @bank = 0
  end

  def card(player)
    puts "#{player.name} добирает карту."
    player.get_card(@deck.get_card)
  end

  def open?
    if @players[0].cards.size == 3 && @players[1].cards.size == 3
      true
    else
      false
    end
  end

  def open(player = nil)
    unless player.nil?
      puts "#{player.name} решил открыть карты!"
    end
    status(true)
    winner?
  end

  def winner?
    player = @players[0].scoring
    croupier = @players[1].scoring

    winner = if player == croupier
      nil
    elsif (player > 21 && croupier > 21) && (21 - player > 21 - croupier)
      @players[0]
    elsif player > 21 && croupier <= 21
      @players[1]
    elsif (player <= 21 && croupier > 21) || 21 - player < 21 - croupier
      @players[0]
    else
      @players[1]
    end

    if winner.nil?
      puts "Ничья! #{@players[0].name}, похоже ты нашёл равного себе соперника!\n\n"
      get_bank(@players)
    else
      puts "Побежадет #{winner.name}!\n\n"
      get_bank([winner])
    end

    @players.each {|plr| plr.return_cards }
    raise "\nКонец партии!\n\n"
  end

  def status(open = nil)
    player, croupier = [], []
    @players[0].cards.each { |card, value| player << "#{card} <= #{value}" }
   if open.nil?
     croupier = Array.new(@players[1].cards.size){ "[**] <= X" }
   else
     @players[1].cards.each { |card, value| croupier << "#{card} <= #{value}" }
   end
    bank =  "#{@bank}$".center(5)
    print '-' * 107 + "\n"
    print "| %3s$ | %-33s" % [@players[0].bank, @players[0].name]
    print "<%5s ( %4s ) %5s>" % ['=' * 5, bank, '=' * 5]
    print "%33s | %3d$ |" % [@players[1].name, @players[1].bank]
    print "\n"

    print "%-47s" % [player.join(', ')]
    print " <%5s%5s>" % ['=' * 5, '=' * 5]
    print "%47s " % [croupier.join(', ')]
    print "\n"
    print '-' * 107 + "\n"
  end
end
