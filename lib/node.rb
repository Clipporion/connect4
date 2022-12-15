# frozen_string_literal: true

# In this class I will store a node containing a value,
# as well as a symbol in case the node is chosen to contain one
# and also all it's neighbor nodes available on the field.
class Node
  attr_reader :value, :symbol, :left, :leftdown, :leftup,
              :up, :down, :right, :rightdown, :rightup

  def initialize(value)
    @value = value
    @symbol = ' '
    @leftup = add_neighbor(value, [-1, 1])
    @up = add_neighbor(value, [0, 1])
    @rightup = add_neighbor(value, [1, 1])
    @left = add_neighbor(value, [-1, 0])
    @right = add_neighbor(value, [1, 0])
    @leftdown = add_neighbor(value, [-1, -1])
    @down = add_neighbor(value, [0, -1])
    @rightdown = add_neighbor(value, [1, -1])
  end

  def add_neighbor(value, move)
    row = value[0] + move[0]
    line = value[1] + move[1]
    [row, line] if (1..7).include?(row) && (1..6).include?(line)
  end

  def add_symbol(symbol)
    @symbol = symbol
  end
end
