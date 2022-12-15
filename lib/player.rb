# frozen_string_literal: true

# used to store the name and symbol of a new player
class Player
  attr_reader :name, :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end
end
