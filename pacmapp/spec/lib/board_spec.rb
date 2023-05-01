# frozen_string_literal: true

require 'set'

describe 'The board (where everything happens)' do
  let(:size_x) { 20 }
  let(:size_y) { 10 }
  let(:pacman) { Lib::Object::Pacman.new(col_x: 0, row_y: 0) }
  let(:walls_set) { Set.new([[1,1],[2,2],[2,3],[4,3],[4,4]]) }
  let(:subject) do
    Lib::Board.new(
      size_x: size_x,
      size_y: size_y,
      pacman: pacman,
      walls_set: walls_set
    )
  end

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

    it 'Pacman final location must be [3,0,3]' do
      expect(subject.pacman_final_location).to eq [3, 0, 3]
    end
  end

  describe 'Trying to move Pac-Man outside the board' do
    before do
      100.times do
        subject.move_pacman(subject.pacman.col_x + 1, subject.pacman.row_y)
        subject.move_pacman(subject.pacman.col_x, subject.pacman.row_y + 1)
      end
    end

    it 'Pacman final location must be at -1, -1 and must have eaten 0 coins' do
      expect(subject.pacman_final_location).to eq [-1, -1, 0]
    end
  end
end
