require 'colorize'
require 'byebug'

class Piece
  MOVES = { black:   [[1, 1], [1, -1]],
            red: [[-1, 1], [-1, -1]],
            king:  [[1, 1], [1, -1], [-1, 1], [-1, -1]]}
  BACK_ROW = { black: 7, red: 0 }

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
    delta.map { |el| (el* multiplier).to_i }
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
    { jump: jump_moves, slide: slide_moves }
  end

  def has_move?
    !moves.all? { |k, v| v.empty? }
  end

  def is_slide?(end_pos)
    slide_moves.include?(end_pos)
  end

  def is_jump?(end_pos)
    jump_moves.include?(end_pos)
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
       jumps << Piece.sum(pos, Piece.times(delta, 2))
      end
    end
    jumps
  end

  def legal_jump?(delta)
    jump_pos = Piece.sum(pos, delta)
    land_pos = Piece.sum(jump_pos, delta)
    board.on_board?(land_pos) && board.empty?(land_pos) &&
      !board.empty?(jump_pos) && board[jump_pos].color != color
  end

  def symbol
    king? ? "K".colorize(color) : "@".colorize(color)
  end

  def can_promote?
    pos[0] == BACK_ROW[color] && !king?
  end

  def king_me
    @king = true
  end

  private

  def move_deltas
    king? ? MOVES[:king] : MOVES[color]
  end
end
