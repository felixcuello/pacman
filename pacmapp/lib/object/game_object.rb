# frozen_string_literal: true

module Lib
  module Object
    #  An object representation in the game
    class GameObject
      include GameException

      REPRESENTATION = '?'

      attr_accessor :col_x, :row_y

      #  Initializes the Game object
      # ------------------------------------------------------
      #  This class is kind of abstract, because the derived
      #  classes can only instanitate this by defininig a
      #  representation string
      def initialize(col_x:, row_y:)
        @col_x = col_x
        @row_y = row_y
      end

      #  Moves the object to that position
      # ------------------------------------------------------
      def move_to(col_x, row_y)
        @col_x = col_x
        @row_y = row_y
      end

      #  Returns true if the object is in that position
      # ------------------------------------------------------
      def position?(col_x, row_y)
        @col_x == col_x && @row_y == row_y
      end
    end
  end
end
