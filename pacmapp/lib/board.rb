# frozen_string_literal: true

require 'set'
require_relative 'game_exception/invalid_board'
require_relative 'object/pacman'
require_relative 'object/wall'

module Lib
  #  This class encapsulates the idea of the board
  #  It holds some business logic, like you cannot do illegal moves on the board
  #  e.g. PacMan cannot move inside walls, or outside the board
  class Board
    include GameException
    include Lib::Object

    COIN_REPRESENTATION = '.'
    EMPTY_SPACE_REPRESENTATION = ' '

    attr_reader :pacman

    def initialize(size_x:, size_y:, pacman:, walls_set: Set.new)
      #  Since everything that aren't walls or pacman, are coins
      #  it's easier to represent coins as "uneaten" and keep track
      #  just of the coins that were eaten
      @coins_eaten = Set.new

      @size_x = size_x
      @size_y = size_y

      check_pacman_position!(pacman)
      @pacman = pacman

      # We have to remember that position because there isn't any coin there
      @initial_pacman_col_x = pacman.col_x
      @initial_pacman_row_y = pacman.row_y

      check_walls_position!(walls_set)
      @walls = walls_set
    end

    #  Returns true if the position is inside the board
    # ------------------------------------------------------
    def inside?(col_x, row_y)
      return true if col_x >= 0 && col_x < @size_x && row_y >= 0 && row_y < @size_y

      false
    end

    #  Returns true if there's a wall at that position
    # ------------------------------------------------------
    def wall_at?(col_x, row_y)
      return true if @walls.member?([col_x, row_y])

      false
    end

    #  Returns true if Pac-Man is at that position
    # ------------------------------------------------------
    def pacman_at?(col_x, row_y)
      return true if col_x == @pacman.col_x && row_y == @pacman.row_y

      false
    end

    #  Moves the pacman to that particular position
    # ------------------------------------------------------
    def move_pacman(new_col_x, new_row_y)
      return if wall_at?(new_col_x, new_row_y) # Pac-Man cannot move into a wall
      return unless inside?(new_col_x, new_row_y) # Pac-Man cannot move outside the board

      @pacman.move_to(new_col_x, new_row_y)

      # There's no coin at the initial Pac-Man position
      return if initial_pacman_position?(new_col_x, new_row_y)

      # Eat the coin if it wasn't eaten already
      @coins_eaten.add([new_col_x, new_row_y])
    end

    #  Returns the number of eaten coins
    # ------------------------------------------------------
    def coins_eaten
      @coins_eaten.size
    end

    #  Returns a printable board
    # ------------------------------------------------------
    def show
      (@size_y - 1).downto(0) do |row_y|
        @size_x.times do |col_x|
          print ' ' if col_x > 0
          if wall_at?(col_x, row_y)
            print Wall::REPRESENTATION
          elsif pacman_at?(col_x, row_y)
            print Pacman::REPRESENTATION
          elsif initial_pacman_position?(col_x, row_y)
            print EMPTY_SPACE_REPRESENTATION
          elsif !@coins_eaten.member?([col_x, row_y])
            print COIN_REPRESENTATION
          else
            print EMPTY_SPACE_REPRESENTATION
          end
        end

        puts ''
      end
    end

    #  Return the stats of the game
    # ------------------------------------------------------
    def show_stats
      puts ''
      puts '--- STATS'
      puts "Pac-Man position = [#{@pacman.col_x},#{@pacman.row_y}]"
      puts "Eaten coins = #{@coins_eaten.size}"
      puts '---'
    end

    private

    #  Returns true if it's the initial pacman position or false otherwise
    # ------------------------------------------------------
    def initial_pacman_position?(col_x, row_y)
      return true if col_x == @initial_pacman_col_x && row_y == @initial_pacman_row_y

      false
    end

    #  Check the pacman position on the board
    # ------------------------------------------------------
    def check_pacman_position!(pacman)
      raise InvalidBoardException('Pac-Man must be inside the board') unless inside?(pacman.col_x, pacman.row_y)
    end

    #  Check the pacman position on the board
    # ------------------------------------------------------
    def check_walls_position!(walls)
      walls.each do |w|
        w_x = w[0]
        w_y = w[1]
        raise InvalidBoard.new("Wall [#{w_x}, #{w_y}] must be inside the board") unless inside?(w_x, w_y)
        raise InvalidBoard.new("Wall [#{w_x}, #{w_y}] can't be placed over the Pac-Man") if pacman_at?(w_x, w_y)
      end
    end
  end
end
