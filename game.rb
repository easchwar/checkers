require_relative './errors'
require_relative './piece'
require_relative './board'
require_relative './player'

class Game

  def initialize(red, black)
    @board = Board.new(true, true)
    @players = { red: red, black: black}
    @turn = :red
  end


  def play
    until @board.over?
      @board.render
      @players[@turn].play_turn(@board)
      switch_turn
    end
    @board.render
    puts "#{@turn} lost!"
  end

  def switch_turn
    @turn = @turn == :red ? :black : :red
  end
end


if __FILE__ == $PROGRAM_NAME
  black = Player.new(:black)
  red = Player.new(:red)
  g = Game.new(red, black)
  g.play
end
