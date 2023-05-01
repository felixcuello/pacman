# frozen_string_literal: true

require 'set'
require_relative 'board'
require_relative 'object/pacman'
require_relative 'object/wall'
require_relative 'game_exception/invalid_movement'

module Lib
  #  This class encapsulates the rules of this game.
  #  Its main purpose is to maintain a coherence in the game and
  #  the objects in it.
  class Game
    include Lib::Object
    include GameException

    DEBUG = false
    CARDINAL_POINTS = Set.new(['N', 'S', 'E', 'W'])
    CARDINAL_MOVEMENT_TO = { 'N' => [0,1], 'S' => [0,-1], 'E' => [1,0], 'W' => [-1,0] }

    attr_reader :board

    def initialize(pacman_game_file)
      parsed_file = parse_pacman_game_file(pacman_game_file)

      walls_set = parse_walls(parsed_file[:walls])
      pacman = Pacman.new(col_x: parsed_file[:pacman_col_x], row_y: parsed_file[:pacman_row_y])
      @board = Board.new(size_x: parsed_file[:board_size_x],
                         size_y: parsed_file[:board_size_y],
                         pacman: pacman,
                         walls_set: walls_set)
      @pacman_movements = parsed_file[:pacman_movements]
    end

    def play!
      @pacman_movements.each do |movement|
        movement&.upcase!

        raise InvalidMovement.new("Cardinal point '#{movement}' is invalid") unless CARDINAL_POINTS.member?(movement)

        new_col_x = @board.pacman.col_x + CARDINAL_MOVEMENT_TO[movement][0]
        new_row_y = @board.pacman.row_y + CARDINAL_MOVEMENT_TO[movement][1]

        next unless @board.inside?(new_col_x, new_row_y) # Ignore movement if outside the board
        next if @board.wall_at?(new_col_x, new_row_y) # Ignore movement if desired movement is a wall

        board.move_pacman(new_col_x, new_row_y)

        #  Turn DEBUG on, only if you want to see how the Pac-Man moves on every movement
        if DEBUG
          puts "--- Move to #{movement} ------------------"
          @board.show
          puts ''
        end
      end
    end

    private

    #  Parses the walls list into a pair of coordinates lists
    # ------------------------------------------------------
    #  Returns a set of coordinates
    def parse_walls(walls_list = [])
      walls_list_size = walls_list.size
      raise InvalidBoardException('The number of walls coordinates are odd') if walls_list_size.odd?

      # This is to avoid duplicates
      walls = Set.new

      i = 0
      while i < walls_list_size
        wall_col_x = walls_list[i]
        wall_row_y = walls_list[i + 1]

        walls.add([wall_col_x, wall_row_y])
        i += 2
      end

      walls
    end

    #  Reads the pacman game file
    # ------------------------------------------------------
    def read_pacman_game(pacman_game_file)
      File.read(pacman_game_file).chomp.chomp
    rescue StandardError => e
      puts "Can't read the file #{PacmanGame_file}"
      raise e
    end

    #  Parses the pacman file
    # ------------------------------------------------------
    def parse_pacman_game_file(pacman_game_file)
      pacman_game = read_pacman_game(pacman_game_file)
                      .strip
                      .split(/\s+/)

      {
        board_size_x: pacman_game[0].to_i,
        board_size_y: pacman_game[1].to_i,
        pacman_col_x: pacman_game[2].to_i,
        pacman_row_y: pacman_game[3].to_i,
        pacman_movements: pacman_game[4].to_s.split(''),
        walls: pacman_game[5..].map(&:to_i)
      }
    end
  end
end
