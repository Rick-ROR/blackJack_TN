#!/usr/bin/ruby -w
require_relative 'lootable'
require_relative 'deck'
require_relative 'card'
require_relative 'players'
require_relative 'croupier'
require_relative 'validation'
require_relative 'casino'
require_relative 'bank'

trap 'SIGINT' do
  puts 'Ctrl+C => Exiting'
  exit
end

casino = Casino.new
casino.greeting
casino.new_player
casino.start_game
