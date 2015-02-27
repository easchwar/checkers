class DummyPlayer

  def initialize(color)
    @color = color
  end

  def play_turn(board)
    i = 0
    begin
      i += 1
      color_pieces = board.pieces.select { |piece| piece.color == @color }
      moves = [color_pieces.sample.pos]
      # debugger
      num_moves = rand(1..2)
      num_moves.times do |move|
        moves << [rand(0...8), rand(0...8)]
      end
      # debugger
      if board.empty?(moves.first) || board[moves.first].color != @color
        raise "whoops"
      end
      board.perform_moves(moves)
    rescue
      retry if i < 10000
      puts "too many tries"
    end
    sleep(2)
  end
end
