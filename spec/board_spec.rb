# frozen_string_literal: true

require './lib/board'
describe Board do
  subject(:board) { described_class.new }

  describe '#build_board' do
    it 'builds a board of one Node object for two 1 digit ranges' do
      node_count = board.build_board((1..1), (1..1)).length

      expect(node_count).to eq(1)
    end

    it 'puts a message unless two ranges are given as arguments' do
      expect(board).to receive(:puts).with('Please input two ranges as arguments')

      board.build_board(1, 1)
    end
  end

  describe '#initialize' do
    it 'without input calls #build_board and saves the result to of 42 nodes to @nodes' do
      node_count = board.nodes.length

      expect(node_count).to eq(42)
    end

    it 'creates a single node board for ranges (1..1), (1..1)' do
      new_board = described_class.new((1..1), (1..1))
      node_count = new_board.nodes.length

      expect(node_count).to eq(1)
    end
  end

  describe '#print_board' do
    it 'prints the board' do
      expect(board).to receive(:print).exactly(55).times
      allow(board).to receive(:puts)
      allow(board).to receive(:print)

      board.print_board
    end

    it 'calls #last_line' do
      allow(board).to receive(:puts)
      expect(board).to receive(:print_last_line)

      board.print_board
    end
  end
end
