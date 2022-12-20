# frozen_string_literal: true

require_relative 'player'
require_relative 'node'
require_relative 'board'

# This class will contain all the necessary game logic to play a game of connect4
# with two players.
class Connect4
  attr_reader :p1, :p2, :board, :game_over, :winner, :moves

  def initialize
    @p1 = nil
    @p2 = nil
    @board = Board.new
    @first_player = true
    @winner = nil
    @game_over = false
    @moves = { left: [-1, 0], right: [1, 0], leftup: [-1, 1], rightup: [1, 1],
               leftdown: [-1, -1], rightdown: [1, -1], down: [0, -1], up: [0, 1] }
  end

  def player_setup
    puts "First player, please enter your name, your symbol is \u25cf"
    name = gets.chomp
    @p1 = Player.new(name, "\u25cf")
    puts "Second player, please enter your name, your symbol is \u25cb"
    name = gets.chomp
    @p2 = Player.new(name, "\u25cb")
  end

  def place_token(player, node)
    node.add_symbol(player.symbol)
  end

  def find_free_node(node, free = @board.nodes[node])
    return free if free.symbol == ' '

    find_free_node(free.up)
  end

  def choose_row(player)
    puts "#{player.name}, please choose a free row to place your token #{player.symbol}"
    input = gets.chomp.to_i
    if @board.rows.include?(input) && @board.nodes[[input, 6]].symbol == ' '
      input
    else
      choose_row(player)
    end
  end

  def winner_detected(player)
    @winner = player
    @game_over = true
  end

  def find_node(start, move, mode = nil, next_node = @board.nodes[[start.value[0] + move[0], start.value[1] + move[1]]])
    counter = 1
    while next_node && next_node.symbol == start.symbol
      start = next_node
      next_node = @board.nodes[[start.value[0] + move[0], start.value[1] + move[1]]]
      counter += 1
    end
    return start if mode == 'start'

    counter
  end

  def find_start_nodes(node)
    res = []
    res.push(find_node(node, @moves[:up], 'start'))
    res.push(find_node(node, @moves[:left], 'start'))
    res.push(find_node(node, @moves[:leftup], 'start'))
    res.push(find_node(node, @moves[:leftdown], 'start'))
    res
  end

  def check_four(array)
    return true if find_node(array[0], @moves[:down]) > 3
    return true if find_node(array[1], @moves[:right]) > 3
    return true if find_node(array[2], @moves[:rightdown]) > 3
    return true if find_node(array[3], @moves[:rightup]) > 3

    false
  end

  def check_winner(node)
    node_array = find_start_nodes(node)
    check_four(node_array)
  end

  def check_full
    (1..7).each { |num| return false if @board.nodes[[num, 6]].symbol == ' ' }
    true
  end

  def game_over_message(mode = 'full')
    case mode
    when 'winner'
      puts "Congratulations #{@winner.name}, you won!"
    when 'full'
      puts 'The board is full and there is no winner. Better luck next time'
    end
  end

  def check_game_over(player, node)
    if check_full
      @game_over = true
      game_over_message
      @board.print_board
    elsif check_winner(node)
      winner_detected(player)
      game_over_message('winner')
      @board.print_board
    end
  end

  def player_turn(player)
    @board.print_board
    input = choose_row(player)
    to_fill = find_free_node([input, 1])
    place_token(player, to_fill)
    check_game_over(player, to_fill)
  end

  def play_game
    player_setup
    until @game_over == true
      if @first_player == true
        player_turn(@p1)
        @first_player = false
      else
        player_turn(@p2)
        @first_player = true
      end
    end
  end
end

game = Connect4.new
game.play_game
