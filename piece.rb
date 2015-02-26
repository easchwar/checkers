require 'colorize'
require 'byebug'

class Piece
  MOVES = { red:   [[1, 1], [1, -1]],
            black: [[-1, 1], [1, 1]],
            king:  [[1, 1], [1, -1], [-1, 1], [-1, -1]]}

  attr_accessor :pos, :board
  attr_reader :color
  attr_writer :king

  def self.sum(pos, delta)
    [pos[0] + delta[0], pos[1] + delta[1]]
  end

  def initialize(pos, color, board)
    @pos = pos
    @board = board
    @color = color
    @king = false
  end

  def king?
    @king
  end

  def slide(delta)
    self.pos = Piece.sum(pos, delta)
  end

  def jump(delta)
  end

  def symbol
    "@".colorize(color)
  end

  def promote?
  end

  private

  def move_deltas
    king? ? MOVES(:king) : MOVES(color)
  end
end
