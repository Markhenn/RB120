# Tic Tac Toe Game

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                   [1, 4, 7], [2, 5, 8], [3, 6, 9],
                   [1, 5, 9], [3, 5, 7]]

  def initialize
    @squares = {}
    reset
  end

  def get_square_at(square)
    @squares[square]
  end

  def set_square_at(square, marker)
    @squares[square].marker = marker
  end

  def unmarked_squares
    @squares.select { |_, sq| sq.unmarked? }.keys
  end

  def full?
    unmarked_squares.empty?
  end

  def someone_won?
    !!detect_winner
  end

  def three_in_a_line(line, marker)
    @squares.values_at(*line).map(&:marker).all? { |mk| mk == marker }
  end

  def detect_winner
    WINNING_LINES.each do |line|
      if three_in_a_line(line, TTTGame::HUMAN_MARKER)
        return TTTGame::HUMAN_MARKER
      elsif three_in_a_line(line, TTTGame::COMPUTER_MARKER)
        return TTTGame::COMPUTER_MARKER
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end
end

class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize(marker = INITIAL_MARKER)
    @marker = marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def to_s
    @marker
  end
end

class Player
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end
end

class TTTGame
  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
  end

  def play
    display_welcome_message
    loop do
      display_board(false)
      loop do
        human_moves
        break if board.someone_won? || board.full?

        computer_moves
        break if board.someone_won?
        display_board
      end
      display_result
      break unless play_again?
      board.reset
      puts "Let's play again!"
      puts
    end
    display_goodbye_message
  end

  private

  def human_moves
    square = nil
    loop do
      puts "Please choose a square from #{board.unmarked_squares.join(', ')}:"
      square = gets.chomp.to_i
      break if board.unmarked_squares.include?(square)
      puts "Sorry! Invalid choice"
    end

    board.set_square_at(square, human.marker)
  end

  def computer_moves
    board.set_square_at(board.unmarked_squares.sample, computer.marker)
  end

  def display_result
    display_board

    case board.detect_winner
    when human.marker then puts 'You win!'
    when computer.marker then puts 'Computer wins!'
    else puts 'It is a tie!'
    end
  end

  def play_again?
    puts 'Type y if you want to play again'
    answer = gets.chomp.downcase
    system 'clear'

    answer.start_with? 'y'
  end

  def display_board(clear=true)
    system 'clear' if clear
    puts "You're a #{human.marker}, Computer is a #{computer.marker}"
    puts "     |     |"
    puts "  #{board.get_square_at(1)}  |  #{board.get_square_at(2)}  |  #{board.get_square_at(3)}"
    puts "     |     |"
    puts " ----+-----+-----"
    puts "     |     |"
    puts "  #{board.get_square_at(4)}  |  #{board.get_square_at(5)}  |  #{board.get_square_at(6)}"
    puts "     |     |"
    puts " ----+-----+-----"
    puts "     |     |"
    puts "  #{board.get_square_at(7)}  |  #{board.get_square_at(8)}  |  #{board.get_square_at(9)}"
    puts "     |     |"
    puts
  end

  def display_welcome_message
    puts 'Welcome to Tic Tac Toe!'
    puts
  end

  def display_goodbye_message
    puts 'Thank you for playing Tic Tac Toe! Goodbye!'
  end
end

game = TTTGame.new
game.play
