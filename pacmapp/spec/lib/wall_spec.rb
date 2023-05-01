# frozen_string_literal: true

describe '(another hit in...) The Wall' do
  describe 'default look' do
    let(:subject) { Lib::Object::Wall.new(col_x: 1, row_y: 2) }

    it 'must be an #' do
      expect(subject.class::REPRESENTATION).to be '#'
    end

    it 'must be at (1,2)' do
      expect(subject.col_x).to eq 1
      expect(subject.row_y).to eq 2
    end
  end
end
