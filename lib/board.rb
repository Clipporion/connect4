# frozen_string_literal: true

require_relative 'node'

# class to store the complete board for the connect4 game consisting of usually
# 42 Node objects and has a method to display the board
class Board
  attr_reader :nodes, :lines, :rows

  def initialize(lines = (1..6), rows = (1..7))
    @lines = lines
    @rows = rows
    @nodes = build_board(@lines, @rows)
  end

  def build_board(lines, rows)
    return puts 'Please input two ranges as arguments' if !lines.is_a?(Range) || !rows.is_a?(Range)

    res = {}
    lines.each do |line|
      rows.each do |row|
        res[[row, line]] = Node.new([row, line])
      end
    end
    res
  end

  def print_board(line = @lines.last, row = 1)
    while line.positive?
      print '|'
      while row <= @rows.last
        print " #{@nodes[[row, line]].symbol} |"
        row += 1
      end
      puts
      line -= 1
      row = 1
    end
    print_last_line(@rows)
  end

  def print_last_line(rows)
    rows.each do |num|
      print "  #{num} "
    end
    puts
  end
end
