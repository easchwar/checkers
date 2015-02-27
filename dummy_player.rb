class DummyPlayer

  def initialize(color)
    @color = color
  end

  def play_turn(board)
    begin
      color_pieces = board.pieces.select { |piece| piece.color == @color }
      moves = []

      color_pieces.shufle.each do |piece|
        if !piece.jump_moves.empty?
          moves << piece.pos
          moves << piece.jump_moves.first
          break
        end
      end

      if moves.empty?
        color_pieces.shuffle.each do |piece|
          if !piece.slide_moves.empty?
            moves << piece.pos
            moves <<piece.slide_moves.sample
            break
          end
        end
      end

      if board.empty?(moves.first) || board[moves.first].color != @color
        raise "whoops"
      end
      board.perform_moves(moves)
    rescue => e
      retry if i < 100
      puts e
    end
    sleep(2)
  end
end
