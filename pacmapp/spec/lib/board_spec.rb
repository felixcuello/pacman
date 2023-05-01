# frozen_string_literal: true

require 'set'

describe 'The board (where everything happens)' do
  let(:size_x) { 20 }
  let(:size_y) { 10 }
  let(:pacman) { Lib::Object::Pacman.new(col_x: 0, row_y: 0) }
  let(:walls_set) { Set.new([[1,1],[2,2],[2,3],[4,3],[4,4]]) }
  let(:subject) { Lib::Board.new(size_x: size_x,
                                size_y: size_y,
                                pacman: pacman,
                                walls_set: walls_set) }


  describe 'invariants at the beginning of the game' do
    it 'Pacman must be inside' do
        expect(subject.inside?(pacman.col_x, pacman.row_y)).to be true
    end

    it 'Walls must be correctly placed' do
        walls_set.each do |w|
        x = w[0]
        y = w[1]

        expect(subject.wall_at?(x,y)).to be true
        end
    end
  end

  describe 'valid Pac-Man movements' do
    before do
      subject.move_pacman(subject.pacman.col_x + 1, subject.pacman.row_y)
      subject.move_pacman(subject.pacman.col_x + 1, subject.pacman.row_y)
      subject.move_pacman(subject.pacman.col_x + 1, subject.pacman.row_y)
    end

    it 'must eat 3 coins when moving (E)ast three times' do
      expect(subject.coins_eaten).to eq 3
    end

    it 'must have moved to the (E)ast three times' do
      expect(subject.pacman.col_x).to eq 3
    end

    it 'must have NOT moved north or south' do
      expect(subject.pacman.row_y).to eq 0
    end
  end

  describe 'Trying to move Pac-Man outside the board' do
    before do
      100.times do
        subject.move_pacman(subject.pacman.col_x + 1, subject.pacman.row_y)
        subject.move_pacman(subject.pacman.col_x, subject.pacman.row_y + 1)
      end
    end

    it 'must have placed the Pac-Man at the top right of the board' do
      expect(subject.pacman_at?(size_x - 1, size_y - 1)).to be true
    end

    it 'must have eaten 28 coins' do
      expect(subject.coins_eaten).to eq 28
    end
  end
end
