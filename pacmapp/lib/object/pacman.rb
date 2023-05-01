# frozen_string_literal: true
require_relative 'game_object'

module Lib
  module Object
    class Pacman < GameObject
      REPRESENTATION = '@'

      def initialize(col_x:, row_y:)
        super
      end
    end
  end
end
