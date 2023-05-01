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

      pacman = Pacman.new(col_x: parsed_file[:pacman_col_x], row_y: parsed_file[:pacman_row_y])
      @board = Board.new(size_x: parsed_file[:board_size_x],
                         size_y: parsed_file[:board_size_y],
                         pacman: pacman,
                         walls_set: parsed_file[:walls])
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
      pacman_game_definition = read_pacman_game(pacman_game_file)
                               .split(/\r?\n/)
                               .map(&:strip)

      board_size = pacman_game_definition[0].split(/\s+/).map(&:to_i)
      pacman_initial_position = pacman_game_definition[1].split(/\s+/).map(&:to_i)

      {
        board_size_x: board_size[0],
        board_size_y: board_size[1],
        pacman_col_x: pacman_initial_position[0],
        pacman_row_y: pacman_initial_position[1],
        pacman_movements: pacman_game_definition[2].split(''),
        walls: Set.new(pacman_game_definition[3..].map { |w| w.split(/\s+/).map(&:to_i) })
      }
    end
  end
end
