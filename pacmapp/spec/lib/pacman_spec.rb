# frozen_string_literal: true

describe 'The Pac-Man @ (waka-waka)' do
  describe 'default look' do
    let(:subject) { Lib::Object::Pacman.new(col_x: 3, row_y: 7) }

    it 'must be an @' do
      expect(subject.class::REPRESENTATION).to be '@'
    end

    it 'must be at (0,0)' do
      expect(subject.col_x).to eq 3
      expect(subject.row_y).to eq 7
    end
  end
end
