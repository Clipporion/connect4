#first methods for checking for 4 connected symbols

def vertical_check(player, start)
  start = @board.nodes[start]
  successor = @board.nodes[start.down]
  counter = 1
  until successor.nil? || successor.symbol != player.symbol
    successor = @board.nodes[successor.down]
    counter += 1
  end
  counter
end

def horizontal_check(player, start_node, start = @board.nodes[start_node])
  predecessor = @board.nodes[start.left]
  successor = @board.nodes[start.right]
  counter = 1
  until successor.nil? || successor.symbol != player.symbol
    successor = @board.nodes[successor.right]
    counter += 1
  end
  until predecessor.nil? || predecessor.symbol != player.symbol
    predecessor = @board.nodes[predecessor.left]
    counter += 1
  end
  counter
end

def diagonal_check_left_up(player, start_node, start = @board.nodes[start_node])
  predecessor = @board.nodes[start.leftup]
  successor = @board.nodes[start.rightdown]
  counter = 1
  until successor.nil? || successor.symbol != player.symbol
    successor = @board.nodes[successor.rightdown]
    counter += 1
  end
  until predecessor.nil? || predecessor.symbol != player.symbol
    predecessor = @board.nodes[predecessor.leftup]
    counter += 1
  end
  counter
end

def diagonal_check_left_down(player, start_node, start = @board.nodes[start_node])
  predecessor = @board.nodes[start.leftdown]
  successor = @board.nodes[start.rightup]
  counter = 1
  until successor.nil? || successor.symbol != player.symbol
    successor = @board.nodes[successor.rightup]
    counter += 1
  end
  until predecessor.nil? || predecessor.symbol != player.symbol
    predecessor = @board.nodes[predecessor.leftdown]
    counter += 1
  end
  counter
end

# tests
describe '#vertical_check' do
  it 'returns the number of vertically connected identical symbols' do
    game.place_token(first, game.board.nodes[[1, 1]])
    game.place_token(first, game.board.nodes[[1, 2]])
    game.place_token(first, game.board.nodes[[1, 3]])
    game.place_token(first, game.board.nodes[[1, 4]])
    result = game.vertical_check(first, [1, 4])
    expect(result).to eq(4)
  end

  it 'works when a differet symbol appears in the row' do
    game.place_token(first, game.board.nodes[[1, 1]])
    game.place_token(second, game.board.nodes[[1, 2]])
    game.place_token(first, game.board.nodes[[1, 3]])
    game.place_token(first, game.board.nodes[[1, 4]])
    result = game.vertical_check(first, [1, 4])
    expect(result).to eq(2)
  end
end

describe '#horizontal_check' do
  it 'returns the number of horizontally connected identical symbols' do
    game.place_token(first, game.board.nodes[[1, 1]])
    game.place_token(first, game.board.nodes[[2, 1]])
    game.place_token(first, game.board.nodes[[3, 1]])
    game.place_token(first, game.board.nodes[[4, 1]])
    result = game.horizontal_check(first, [4, 1])
    expect(result).to eq(4)
  end

  it 'works when a differet symbol appears in the row' do
    game.place_token(first, game.board.nodes[[1, 1]])
    game.place_token(second, game.board.nodes[[2, 1]])
    game.place_token(first, game.board.nodes[[3, 1]])
    game.place_token(first, game.board.nodes[[4, 1]])
    result = game.horizontal_check(first, [4, 1])
    expect(result).to eq(2)
  end
end

describe '#diagonal_check_left_up' do
  it 'returns the number of diagonally connected identical symbols up_left to down-right' do
    game.place_token(first, game.board.nodes[[1, 4]])
    game.place_token(first, game.board.nodes[[2, 3]])
    game.place_token(first, game.board.nodes[[3, 2]])
    game.place_token(first, game.board.nodes[[4, 1]])
    result = game.diagonal_check_left_up(first, [2, 3])
    expect(result).to eq(4)
  end

  it 'works when a differet symbol appears in the row' do
    game.place_token(first, game.board.nodes[[1, 4]])
    game.place_token(second, game.board.nodes[[2, 3]])
    game.place_token(first, game.board.nodes[[3, 2]])
    game.place_token(first, game.board.nodes[[4, 1]])
    result = game.diagonal_check_left_up(first, [4, 1])
    expect(result).to eq(2)
  end
end

describe '#diagonal_check_left_down' do
  it 'returns the number of diagonally connected identical symbols up_left to down-right' do
    game.place_token(first, game.board.nodes[[1, 1]])
    game.place_token(first, game.board.nodes[[2, 2]])
    game.place_token(first, game.board.nodes[[3, 3]])
    game.place_token(first, game.board.nodes[[4, 4]])
    result = game.diagonal_check_left_down(first, [4, 4])
    expect(result).to eq(4)
  end

  it 'works when a differet symbol appears in the row' do
    game.place_token(first, game.board.nodes[[1, 1]])
    game.place_token(first, game.board.nodes[[2, 2]])
    game.place_token(second, game.board.nodes[[3, 3]])
    game.place_token(first, game.board.nodes[[4, 4]])
    result = game.diagonal_check_left_down(first, [1, 1])
    expect(result).to eq(2)
  end
end
