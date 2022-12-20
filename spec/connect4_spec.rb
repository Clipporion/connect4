# frozen_string_literal: true

require './lib/player'
require './lib/node'
require './lib/board'
require './lib/connect4'

describe Connect4 do
  subject(:game) { described_class.new }
  let(:first) { instance_double(Player, name: 'Max', symbol: "\u25cf") }
  let(:second) { instance_double(Player, name: 'Linda', symbol: "\u25cb") }

  describe '#player_setup' do
    it 'creates two player objects and stores them as @p1 and @p2' do
      allow(game).to receive(:gets).and_return('Max', 'Linda')
      allow(game).to receive(:puts)
      game.player_setup
      p1_name = game.p1.name
      p2_name = game.p2.name

      expect(p1_name).to eq('Max')
      expect(p2_name).to eq('Linda')
    end

    it "gives @p1 the symbol \u25cf and @p2 the symbol \u25cb" do
      allow(game).to receive(:gets).and_return('Max', 'Linda')
      allow(game).to receive(:puts)
      game.player_setup
      p1_symbol = game.p1.symbol
      p2_symbol = game.p2.symbol

      expect(p1_symbol).to eq("\u25cf")
      expect(p2_symbol).to eq("\u25cb")
    end
  end

  describe '#place_token' do
    it 'lets the player choose a row and puts the player symbol in the next free place' do
      game.place_token(first, game.board.nodes[[1, 1]])
      filled_node = game.board.nodes[[1, 1]].symbol

      expect(filled_node).to eq("\u25cf")
    end
  end

  describe '#find_free_node' do
    it 'finds the bottom node in an empty row' do
      free_node = game.find_free_node([1, 1])

      expect(free_node).to eq(game.board.nodes[[1, 1]])
    end

    it 'finds the third line node when 2 nodes were already filled' do
      game.place_token(first, game.board.nodes[[2, 1]])
      game.place_token(first, game.board.nodes[[2, 2]])

      free_node = game.find_free_node([2, 1])

      expect(free_node).to eq(game.board.nodes[[2, 3]])
    end
  end

  describe '#choose_row' do
    it 'returns the input integer in case there is a free node in input-row' do
      allow(game).to receive(:puts)
      allow(game).to receive(:gets).and_return('1')
      expect(game).to receive(:choose_row).and_return(1)
      game.choose_row(first)
    end

    it 'calls itself again when the input is invalid' do
      allow(game).to receive(:puts).twice
      allow(game).to receive(:gets).and_return('10', '2')
      expect(game).to receive(:choose_row).and_return(2)
      game.choose_row(first)
    end

    it 'calls itself again when row is full' do
      game.place_token(first, game.board.nodes[[3, 6]])
      allow(game).to receive(:puts).twice
      allow(game).to receive(:gets).and_return('3', '2')
      expect(game).to receive(:choose_row).and_return(2)
      game.choose_row(first)
    end
  end

  describe '#winner_detected' do
    it 'sets the winner to the right player and @game_over to true' do
      game.winner_detected(first)

      expect(game.winner.name).to eq('Max')
      expect(game.game_over).to be true
    end
  end

  describe '#find_node' do
    context 'used to find the start node and count to the last node with same symbol' do
      before(:each) do
        (1..6).each do |line|
          (1..7).each do |row|
            game.place_token(first, game.board.nodes[[row, line]])
          end
        end
      end

      it 'returns the first node in a row in mode start vertically' do
        start_node = game.board.nodes[[3, 1]]
        move = game.moves[:left]
        mode = 'start'
        res = game.find_node(start_node, move, mode)
        expect(res).to eq(game.board.nodes[[1, 1]])
      end

      it 'returns the correct node in case of a different symbol being next' do
        game.place_token(second, game.board.nodes[[1, 1]])
        start_node = game.board.nodes[[4, 1]]
        move = game.moves[:left]
        mode = 'start'
        res = game.find_node(start_node, move, mode)
        expect(res).to eq(game.board.nodes[[2, 1]])
      end

      it 'works diagonally left_up' do
        game.place_token(second, game.board.nodes[[2, 5]])
        start_node = game.board.nodes[[4, 3]]
        move = game.moves[:leftup]
        mode = 'start'
        res = game.find_node(start_node, move, mode)
        expect(res).to eq(game.board.nodes[[3, 4]])
      end

      it 'works diagonally left_down' do
        game.place_token(second, game.board.nodes[[4, 4]])
        start_node = game.board.nodes[[3, 3]]
        move = game.moves[:leftdown]
        mode = 'start'
        res = game.find_node(start_node, move, mode)
        expect(res).to eq(game.board.nodes[[1, 1]])
      end
    end

    context 'counts the number of connecting symbols when no mode is given' do
      it 'works vertically' do
        start_node = game.board.nodes[[1, 4]]
        move = game.moves[:down]
        res = game.find_node(start_node, move)
        expect(res).to eq(4)
      end

      it 'works horizontally' do
        game.place_token(second, game.board.nodes[[5, 1]])
        start_node = game.board.nodes[[1, 1]]
        move = game.moves[:right]
        res = game.find_node(start_node, move)
        expect(res).to eq(4)
      end

      it 'works diagonally' do
        game.place_token(second, game.board.nodes[[5, 5]])
        start_node = game.board.nodes[[1, 1]]
        move = game.moves[:rightup]
        res = game.find_node(start_node, move)
        expect(res).to eq(4)
      end
    end
  end

  describe '#find_start_nodes' do
    context 'used to get an array of all the nodes to start for counting the connected symbols' do
      it 'returns an array of 4 nodes' do
        game.place_token(first, game.board.nodes[[1, 1]])
        start_node = game.board.nodes[[1, 1]]
        res = game.find_start_nodes(start_node)
        expect(res.length).to eq(4)
      end
    end
  end

  describe '#check_four' do
    context 'it finds all start nodes from the chosen node and returns true if there is a 4 symbol lane' do
      it 'returns true when when for one lane of 4 symbols' do
        game.place_token(first, game.board.nodes[[1, 1]])
        game.place_token(first, game.board.nodes[[2, 1]])
        game.place_token(first, game.board.nodes[[3, 1]])
        game.place_token(first, game.board.nodes[[4, 1]])
        start_node = game.board.nodes[[3, 1]]
        res = game.check_four(game.find_start_nodes(start_node))
        expect(res).to be true
      end

      it 'returns false on an empty board' do
        game.place_token(first, game.board.nodes[[3, 1]])
        start_node = game.board.nodes[[3, 1]]
        res = game.check_four(game.find_start_nodes(start_node))
        expect(res).to be false
      end
    end
  end

  describe '#check_full' do
    before do
      (1..6).each do |line|
        (1..7).each do |row|
          game.place_token(first, game.board.nodes[[row, line]])
        end
      end
    end

    it 'returns true when the board is filled' do
      res = game.check_full
      expect(res).to be true
    end

    it 'returns false when the board is not filled' do
      np = Player.new('Mario', ' ')
      game.place_token(np, game.board.nodes[[7, 6]])
      res = game.check_full
      expect(res).to be false
    end
  end

  describe '#player_turn' do
    it 'lets the player choose a row and inserts the symbol in the free node' do
      allow(game).to receive(:puts)
      allow(game).to receive(:gets).and_return('1')
      game.player_turn(first)

      filled_node = game.board.nodes[[1, 1]].symbol
      expect(filled_node).to eq(first.symbol)
    end

    it 'lets the player choose a row and inserts the symbol in second line if first is filled' do
      game.place_token(first, game.board.nodes[[1, 1]])
      allow(game).to receive(:puts)
      allow(game).to receive(:gets).and_return('1')
      game.player_turn(first)

      filled_node = game.board.nodes[[1, 2]].symbol
      expect(filled_node).to eq(first.symbol)
    end
  end
end
