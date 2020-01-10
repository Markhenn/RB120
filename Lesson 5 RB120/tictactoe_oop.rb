# Tic Tac Toe Game

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                   [1, 4, 7], [2, 5, 8], [3, 6, 9],
                   [1, 5, 9], [3, 5, 7]]

  def initialize
    @squares = {}
    reset
  end

  def []=(square, marker)
    @squares[square].marker = marker
  end

  def unmarked_squares
    @squares.select { |_, sq| sq.unmarked? }.keys
  end

  def full?
    unmarked_squares.empty?
  end

  def someone_won?
    !!winning_marker
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts " ----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts " ----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  def winning_marker
    WINNING_LINES.each do |line|
      next if @squares[line.first].unmarked?

      return marker_at(line.first) if three_in_a_line(line)
    end
    nil
  end

  private

  def three_in_a_line(line)
    @squares.values_at(*line[1..-1]).map(&:marker).all? do |mk|
      mk == marker_at(line.first)
    end
  end

  def marker_at(square)
    @squares[square].marker
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

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @first_to_move = @computer
    @current_player = @first_to_move
  end

  def play
    display_welcome_message
    loop do
      display_board
      loop do
        current_player_moves
        break if board.someone_won? || board.full?

        clear_screen_and_display_board if human_turn?
      end
      display_result
      break unless play_again?
      reset
      display_play_again_message
    end
    display_goodbye_message
  end

  private

  attr_reader :board, :human, :computer

  def human_turn?
    @current_player == @human
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_player = @computer
    else
      computer_moves
      @current_player = @human
    end
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end

  def reset
    board.reset
    @current_player = @first_to_move
  end

  def human_moves
    square = nil
    loop do
      puts "Please choose a square from #{board.unmarked_squares.join(', ')}:"
      square = gets.chomp.to_i
      break if board.unmarked_squares.include?(square)
      puts "Sorry! Invalid choice"
    end

    board[square] = human.marker
  end

  def computer_moves
    square = board.unmarked_squares.sample
    board[square] = computer.marker
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker then puts 'You win!'
    when computer.marker then puts 'Computer wins!'
    else puts 'It is a tie!'
    end
  end

  def clear
    system 'clear'
  end

  def play_again?
    puts 'Type y if you want to play again'
    answer = gets.chomp.downcase
    clear

    answer.start_with? 'y'
  end

  def display_board
    puts "You're a #{human.marker}, Computer is a #{computer.marker}"
    puts
    board.draw
    puts
  end

  def clear_screen_and_display_board
    clear
    display_board
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
