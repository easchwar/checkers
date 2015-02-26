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

  def slide_piece(start_pos, end_pos)
  end

  def jump_piece(start_pos, end_pos)
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
  end
end
