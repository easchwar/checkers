require_relative './errors'
require_relative './piece'
require_relative './board'
require_relative './player'

class Game

  def initialize(board, red, black)
    @board = board
    @players = { red: red, black: black}
    @turn = :red
  end


  def play
    until @board.over?
      @board.show
      @players[@turn].play_turn(@board)
      switch_turn
    end
    @board.show
    puts "#{@turn} lost!"
  end

  def switch_turn
    @turn = @turn == :red ? :black : :red
  end
end


if __FILE__ == $PROGRAM_NAME
  black = Player.new(:black)
  red = Player.new(:red)
  board = Board.new(true)
  g = Game.new(board, red, black)
  g.play
end
