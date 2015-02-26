require_relative './piece'
require_relative './errors'
require 'colorize'

class Board
  BOARD_SIZE = 8
  BACKGROUND = [:white, :light_white]

  def initialize(populate = true, in_test = false)
    @grid = Array.new(size) { Array.new(size) }
    populate_board(in_test) if populate
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def []=(pos, val)
    @grid[pos[0]][pos[1]] = val
  end

  def empty?(pos)
    self[pos].nil?
  end

  def on_board?(pos)
    pos.all? { |x| x.between?(0, size - 1) }
  end

  def pieces
    @grid.flatten.compact
  end

  def win?(color)
    pieces.all? { |piece| piece.color == color }
  end

  def over?
    win?(:red) || win?(:black)
  end

  def perform_moves(move_seq)
    raise MoveError.new("Invalid move sequence") if move_seq.length < 2

    if move_seq.length == 2
      move_piece(move_seq.first, move_seq.last)
      return
    end

    move_seq.each_index do |idx|
      next if idx == move_seq.length - 1

      unless self[move_seq[idx]].is_jump?(move_seq[idx + 1])
        raise MoveError.new("Illegal jump in move sequence")
      end

      jump_piece(move_seq[idx], move_seq[idx + 1])
    end
  end

  def move_piece(start_pos, end_pos)
    raise MoveError.new("No piece there") if empty?(start_pos)
    piece = self[start_pos]

    if piece.is_slide?(end_pos)
      slide_piece(start_pos, end_pos)
    elsif piece.is_jump?(end_pos)
      jump_piece(start_pos, end_pos)
    else
      raise MoveError.new("Illegal Move")
    end

    self[end_pos].king_me if self[end_pos].can_promote?
  end

  def slide_piece(start_pos, end_pos)
    self[end_pos] = self[start_pos]
    self[start_pos] = nil
    self[end_pos].pos = end_pos
  end

  def jump_piece(start_pos, end_pos)
    delta = Piece.times(Piece.subtract(end_pos, start_pos), 0.5)
    jump_pos = Piece.sum(start_pos, delta)
    self[end_pos] = self[start_pos]
    self[start_pos] = nil
    self[jump_pos] = nil
    self[end_pos].pos = end_pos
  end

  def size
    BOARD_SIZE
  end

  def render
    render_string = "  "
    render_string << ("0".."7").to_a.join(" ")
    render_string << "\n"
    @grid.each_with_index do |row, row_idx|
      render_string << "#{row_idx} "
      row.each_index do |col_idx|
        pos = [row_idx, col_idx]
        output = (empty?(pos) ? "  " : self[pos].symbol + " ")
        bg_idx = (pos[0] + pos[1]) % 2
        render_string << output.colorize(:background => BACKGROUND[bg_idx])
      end
      render_string << "\n"
    end
    puts render_string
  end

  def populate_board(in_test)
    if in_test
      self[[1,2]] = Piece.new([1,2], :red, self)
      self[[0,3]] = Piece.new([0,3], :black, self)
      return
    end

    (0...3).each do |x|
      (0...8).each do |y|
        self[[x, y]] = Piece.new([x, y], :black, self) if (x + y).odd?
      end
    end

    (5...8).each do |x|
      (0...8).each do |y|
        self[[x, y]] = Piece.new([x, y], :red, self) if (x + y).odd?
      end
    end
  end
end


if __FILE__ == $PROGRAM_NAME
  b = Board.new(false)
  b[[0,1]] = Piece.new([0,1],:black, b)
  b[[1,2]] = Piece.new([1,2],:red, b)
  # b[[2,3]] = Piece.new([2,3],:red, b)
  b[[3,4]] = Piece.new([3,4],:red, b)
  # b[[5,6]] = Piece.new([5,6],:red, b)
  b.render
  # p b.perform_moves([[0,3],[1,4],[2,3],[3,2]])
  p b.perform_moves([[0,1],[2,3],[4,5]])
  b.render
end
