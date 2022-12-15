# frozen_string_literal: true

require './lib/player'

describe Player do
  subject(:p1) { described_class.new('Max', "\u25cf") }

  describe '#initialize' do
    it 'creates a new player with name' do
      name = p1.name

      expect(name).to eq('Max')
    end

    it 'creates a new player with a symbol' do
      symbol = p1.symbol

      expect(symbol).to eq("\u25cf")
    end
  end
end
