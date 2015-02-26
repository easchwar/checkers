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
    puts "#{@color}, select piece to move: "
    start_pos = get_input

    raise MoveError.new("No piece present") if board.empty?(start_pos)

    unless board[start_pos].color == @color
      raise MoveError.new("Wrong color piece")
    end

    puts "#{@color}, select destination: "
    end_pos = get_input

    [start_pos,end_pos]
  end

  def get_input
    input = gets.chomp.split(/[, ]+/)

    unless input.length == 2 && input.all? { |idx| idx.match(/[0-7]/)}
      raise ParsingError.new("Input two comma separated indices between 0-7")
    end

    input.map(&:to_i)
  end

  def make_move(move, board)
    board.move_piece(move[0],move[1])
  end
end
