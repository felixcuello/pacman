# frozen_string_literal: true

describe 'The Pac-Man Game' do
  describe 'Check sample game works' do
    # BOARD
    # ---------
    # . . . . .
    # . . # . .
    # . @ # . .
    # . . . . .
    # . # . . .
    let(:sample_pacman_game) { '5 5 1 2 NNESEESWNWW 1 0 2 2 2 3' }

    before do
      allow_any_instance_of(Lib::Game).to receive(:read_pacman_game).and_return(sample_pacman_game)
    end

    it 'must have eaten 7 coins' do
      game = Lib::Game.new('no_file')
      game.play!

      expect(game.board.coins_eaten).to eq(7)
    end

    it 'Pac-Man must be at x=1, y=4' do
      game = Lib::Game.new('no_file')
      game.play!

      expect(game.board.pacman.col_x).to eq(1)
      expect(game.board.pacman.row_y).to eq(4)
    end
  end

  describe 'Board that only contains impossible moves' do
    # BOARD
    # ---------
    # # # # # #
    # # # # # #
    # # # # # #
    # # # # # #
    # @ # # # #
    let(:sample_pacman_game) { '5 5 0 0 NSEWNSEWNSEW 1 0 2 0 3 0 4 0 0 1 1 1 2 1 3 1 4 1 0 2 1 2 2 2 3 2 4 2 0 3 1 3 2 3 3 3 4 3 0 4 1 4 2 4 3 4 4 4' }

    before do
      allow_any_instance_of(Lib::Game).to receive(:read_pacman_game).and_return(sample_pacman_game)
    end

    it 'must have eaten 0 coins' do
      game = Lib::Game.new('no_file')
      game.play!

      expect(game.board.coins_eaten).to eq(0)
    end

    it 'Pac-Man ate NO coins' do
      game = Lib::Game.new('no_file')
      game.play!

      expect(game.board.pacman.col_x).to eq(0)
      expect(game.board.pacman.row_y).to eq(0)
    end
  end

  describe 'No wall board' do
    # BOARD
    # ---------
    # . . . . .
    # . . . . .
    # . . . . .
    # . . . . .
    # @ . . . .
    let(:sample_pacman_game) { '5 5 0 0 NNNNNESSSSSENNNNNESSSSSENNNNN' }

    before do
      allow_any_instance_of(Lib::Game).to receive(:read_pacman_game).and_return(sample_pacman_game)
    end

    it 'must have eaten 0 coins' do
      game = Lib::Game.new('no_file')
      game.play!

      # Board is 5x5, however there's no coin at Pac-Man's initial position
      expect(game.board.coins_eaten).to eq(24)
    end

    it 'Pac-Man ate NO coins' do
      game = Lib::Game.new('no_file')
      game.play!

      expect(game.board.pacman.col_x).to eq(4)
      expect(game.board.pacman.row_y).to eq(4)
    end
  end
end
