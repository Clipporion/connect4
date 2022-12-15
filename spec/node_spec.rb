# frozen_string_literal: true

require './lib/node'

describe Node do
  subject(:node) { described_class.new([2, 2]) }

  describe '#initialize' do
    it 'creates a new node with a specified value' do
      value = node.value

      expect(value).to eq([2, 2])
    end

    it 'creates a node with a symbol add to a whitespace' do
      symbol = node.symbol

      expect(symbol).to eq(' ')
    end

    it 'creates 8 correct neighbors' do
      leftup = node.leftup
      up = node.up
      rightup = node.rightup
      left = node.left
      right = node.right
      leftdown = node.leftdown
      down = node.down
      rightdown = node.rightdown

      expect(leftup).to eq([1, 3])
      expect(up).to eq([2, 3])
      expect(rightup).to eq([3, 3])
      expect(left).to eq([1, 2])
      expect(right).to eq([3, 2])
      expect(leftdown).to eq([1, 1])
      expect(down).to eq([2, 1])
      expect(rightdown).to eq([3, 1])
    end
  end

  describe '#add_neighbor' do
    it 'creates a neighbor in case the field contains one' do
      neighbor = node.add_neighbor([2, 2], [1, 1])

      expect(neighbor).to eq([3, 3])
    end

    it 'returns nil if the field does not contain the neighbor' do
      neighbor = node.add_neighbor([7, 6], [1, 1])

      expect(neighbor).to be nil
    end
  end

  describe '#add_symbol' do
    it 'adds the symbol in case the node is chosen' do
      node.add_symbol("\u25cf")
      symbol = node.symbol

      expect(symbol).to eq("\u25cf")
    end
  end
end
