# from https://gist.github.com/acook/4190379

require 'io/console'

class PlayerInput

  # Reads keypresses from the user including 2 and 3 escape character sequences.
  def self.read_char
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!

    return input
  end

  # oringal case statement from:
  # http://www.alecjacobson.com/weblog/?p=75
  def self.keyboard_input(board)
    arr = [0,0]
    move_seq = []
    loop do
      c = PlayerInput.read_char

      case c
      when " " # space
        move_seq << arr.dup
      when "\r" # return
        return move_seq
      when "\e" # escape
        move_seq = []
      when "\e[A" # up arrow
        # cursor up (if possible)
        arr[0] -= 1 if arr[0] > 0
      when "\e[B" # down arrow
        arr[0] += 1 if arr[0] < 7
        # cursor down (if..)
      when "\e[C" # right arrow
        arr[1] += 1 if arr[1] < 7
        # cursor right (if..)
      when "\e[D" # left arrow
        arr[1] -= 1 if arr[1] > 0
        # cursor left (if..)
      when "\u0003" # ctrl c
        # exits program
        exit 0
      end
      board.show(move_seq, arr)
      puts "#{move_seq.length - 1} moves selected" if move_seq.length > 1
    end
    raise RuntimeError.new("why are you here")
  end
end

if __FILE__ == $PROGRAM_NAME
  arr = [0, 0]
  p PlayerInput.keyboard_input(arr)
end
