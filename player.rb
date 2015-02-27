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
    sequence = get_input
    start_pos = sequence.first

    raise MoveError.new("No piece present") if board.empty?(start_pos)

    unless board[start_pos].color == @color
      raise MoveError.new("Wrong color piece")
    end

    sequence
  end

  def get_input
    input = gets.chomp.split(/[, ]+/)

    unless input.all? { |idx| idx.match(/[0-7]/)}
      raise ParsingError.new("Input two comma separated indices between 0-7")
    end

    raise ParsingError.new("Invalid input string") if input.length.odd?

    collect_indices(input)
  end

  def collect_indices(input)
    indices = []
    temp = []
    input.each_index do |i|
      temp << input[i].to_i
      if i.odd?
        indices << temp
        temp = []
      end
    end
    indices
  end

  def make_move(sequence, board)
    board.perform_moves(sequence)
  end
end
