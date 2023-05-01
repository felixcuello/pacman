# frozen_string_literal: true
require_relative 'game_object'
require_relative '../../lib/game'

module Lib
  module Object
    class Wall < GameObject
      REPRESENTATION = '#'

      def initialize(col_x:, row_y:)
        super
      end
    end
  end
end
