class Player

  def initialize(color)
    @color = color
  end

  def play_turn(board)
    begin
      make_move(get_move(board), board)
    rescue MoveError => e
      board.show
      puts e
      retry
    rescue ParsingError =>
      board.show
      puts e
      retry
    end
  end

  def get_move(board)
    puts "#{@color}, select a move sequence: "
    sequence = get_input(board)

    raise MoveError.new("must choose a move") if sequence.length < 2

    start_pos = sequence.first

    raise MoveError.new("No piece present") if board.empty?(start_pos)

    unless board[start_pos].color == @color
      raise MoveError.new("Wrong color piece")
    end

    sequence
  end

  def get_input(board)
    PlayerInput.keyboard_input(board)
  end

  def make_move(sequence, board)
    board.perform_moves(sequence)
  end
end
