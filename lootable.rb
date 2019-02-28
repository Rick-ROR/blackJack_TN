#!/usr/bin/ruby -w

class LooTable
  attr_reader :bank

  def initialize(deck, bet, player, croupier)
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
    if @player.cards.size == 3 && @player.cards.size == 3
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
    player = @player.scoring
    croupier = @croupier.scoring

    winner = if player == croupier
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

    if winner.nil?
      puts "Ничья! #{@player.name}, похоже ты нашёл равного себе соперника!\n\n"
      get_bank([@player, @croupier])
    else
      puts "Побежадет #{winner.name}!\n\n"
      get_bank([winner])
    end

    [@player, @croupier].each {|plr| plr.return_cards }
    raise "\nКонец партии!\n\n"
  end

  def status(open = nil)
    player, croupier = [], []
    @player.cards.each { |card| player << "[#{card.value} #{card.suit}] <= #{card.point}" }
   if open.nil?
     croupier = Array.new(@croupier.cards.size){ "[**] <= X" }
   else
     @croupier.cards.each { |card| croupier << "[#{card.value} #{card.suit}] <= #{card.point}" }
   end
    bank =  "#{@bank}$".center(5)
    print "\n" + '-' * 107 + "\n"
    print "| %3s$ | %-33s" % [@player.bank, @player.name]
    print "<%5s ( %4s ) %5s>" % ['=' * 5, bank, '=' * 5]
    print "%33s | %3d$ |" % [@croupier.name, @croupier.bank]
    print "\n"

    print "%-47s" % [player.join(', ')]
    print " <%5s%5s>" % ['=' * 5, '=' * 5]
    print "%47s " % [croupier.join(', ')]
    print "\n"
    print '-' * 107 + "\n\n"
  end
end
