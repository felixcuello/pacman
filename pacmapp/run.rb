# frozen_string_literal: true

require_relative 'lib/game'

#  Check arguments or show usage
if ARGV.count != 1
  print <<USAGE

  Thanks for using pac-man!, here's how to run this script:


  run.rb <pacman_game_definition.txt>


USAGE
  exit(1)
end

game = Lib::Game.new(ARGV[0])

puts ''
puts '=== Initial position of the board ==='
game.board.show

game.play!

puts ''
puts '=== Final position after pacman movements ==='
game.board.show
game.board.show_stats
