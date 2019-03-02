#!/usr/bin/ruby -w
require_relative 'lootable'
require_relative 'deck'
require_relative 'card'
require_relative 'player'
require_relative 'croupier'
require_relative 'validation'
require_relative 'interface'
require_relative 'casino'

trap 'SIGINT' do
  puts 'Ctrl+C => Exiting'
  exit
end

casino = Casino.new
casino.new_player
casino.start_game
