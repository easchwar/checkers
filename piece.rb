require 'colorize'
require 'byebug'

class Piece
  MOVES = { red:   [[1, 1], [1, -1]],
            black: [[-1, 1], [-1, -1]],
            king:  [[1, 1], [1, -1], [-1, 1], [-1, -1]]}

  attr_accessor :pos, :board
  attr_reader :color
  attr_writer :king

  def self.sum(pos, delta)
    [pos[0] + delta[0], pos[1] + delta[1]]
  end

  def self.subtract(pos, delta)
    [pos[0] - delta[0], pos[1] - delta[1]]
  end

  def self.times(delta, multiplier)
    delta.map { |el| el* multiplier }
  end

  def initialize(pos, color, board, king = false)
    @pos = pos
    @board = board
    @color = color
    @king = king
  end

  def king?
    @king
  end

  def moves
  end

  def slide_moves
    slides = move_deltas.map { |delta| Piece.sum(pos, delta) }

    slides.select do |move|
      board.on_board?(move) && board.empty?(move)
    end
  end

  def jump_moves
    jumps = []
    move_deltas.each do |delta|
      if legal_jump?(delta)
       jumps << Piece.sum(pos, delta)
      end
    end
    jumps
  end

  def legal_jump?(delta)
    jump_pos = Piece.sum(pos, delta)
    land_pos = Piece.sum(jump_pos, delta)
    board.on_board?(jump_pos) && !board.empty?(jump_pos) &&
     board[jump_pos].color != color && board.on_board?(land_pos) &&
     board.empty?(land_pos)
  end

  def symbol
    "@".colorize(color)
  end

  def promote?
  end

  private

  def move_deltas
    king? ? MOVES[:king] : MOVES[color]
  end
end
