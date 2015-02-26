require_relative './piece'
require 'colorize'

class Board
  BOARD_SIZE = 8
  BACKGROUND = [:white, :light_white]

  def initialize(populate = true)
    @grid = Array.new(size) { Array.new(size) }
    populate_board if populate
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

  def slide_piece(start_pos, end_pos)
    self[end_pos] = self[start_pos]
    self[start_pos] = nil
    self[end_pos].pos = end_pos
  end

  def jump_piece(start_pos, jump_pos, end_pos)
    self[end_pos] = self[start_pos]
    self[start_pos] = nil
    self[jump_pos] = nil
    self[end_pos].pos = end_pos
  end

  def size
    BOARD_SIZE
  end

  def render
    render_string = ""
    @grid.each_with_index do |row, row_idx|
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

  def populate_board
    self[[0,0]] = Piece.new([0,0], :red, self)
    self[[1,1]] = Piece.new([1,1], :black, self)
  end
end


if __FILE__ == $PROGRAM_NAME
  b = Board.new
  b.render
  puts ""
  b.jump_piece([0,0],[1,1],[2,2])
  b.render
  puts ""
  b.slide_piece([2,2],[3,1])
  b.render
end
