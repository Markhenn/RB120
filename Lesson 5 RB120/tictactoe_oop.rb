# Tic Tac Toe Game

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                   [1, 4, 7], [2, 5, 8], [3, 6, 9],
                   [1, 5, 9], [3, 5, 7]]

  DELIMITER = ','
  END_DELIM = 'or'

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

  def join_unmarked_squares
    joinor(self.unmarked_squares)
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

  def joinor(array, del=DELIMITER, ending=END_DELIM)
    if array.size > 1
      first_part = array[0..-2].join("#{del} ")
      return "#{first_part} #{ending} #{array[-1]}"
    end
    array.first
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
  attr_reader :marker, :name

  def initialize
    @name = set_name
  end
end

class Human < Player
  def pick_marker(markers)
    answer = nil
    loop do
      puts "Please pick a single letter from the alphabet as your marker (A-Z)"
      answer = gets.chomp.upcase
      break if markers.include? answer
      puts "Sorry invalid choice!"
    end

    @marker = answer
  end

  private

  def set_name
    answer = nil
    loop do
      puts "Hey what is your name?"
      answer = gets.chomp
      break answer if answer.size > 1
      puts "Sorry that is too short, at least 2 letters please!"
    end
  end
end

class Computer < Player
  COMPUTERS = %w(R2D2 C3PO Wall-E)
  def pick_marker(markers)
    @marker = markers.sample
  end

  private

  def set_name
    COMPUTERS.sample
  end
end

class Score
  def initialize
    @rounds_to_win = nil
    @round_winner = reset
  end

  def reset
    @round_winner = Hash.new(0)
  end

  def display_round
    puts "Round #{rounds_played + 1}"
  end

  def display_round_stats
    puts
    puts "#{rounds_played} rounds have been played"
    puts "#{@rounds_to_win} wins needed to win the game"
    puts
    display_win_counts
    puts
  end

  def game_over?
    @round_winner.values.any? { |wins| wins >= @rounds_to_win }
  end

  def <<(winner)
    @round_winner[winner] += 1
  end

  def set_rounds_to_win
    answer = nil
    loop do
      puts "How many wins or ties should end the game?"
      puts "Choose from 1 and 10 rounds"
      answer = gets.chomp.to_i
      break if (1..10).to_a.include? answer
      puts "Sorry, invalid answer! Type a number from 1 and 10"
    end
    @rounds_to_win = answer
  end

  private

  def display_win_counts
    @round_winner.each do |winner, count| 
      next if winner.nil?
      puts "#{winner.name} won #{count} rounds"
    end
  end

  def rounds_played
    return 0 if @round_winner.empty?
    @round_winner.values.reduce(:+)
  end
end

class TTTGame

  MARKERS = ("A".."Z").to_a

  def initialize
    @board = Board.new
    @human = Human.new
    @computer = Computer.new
    @first_to_move = @human
    @current_player = @first_to_move
    @score = Score.new
  end

  def play
    start_game
    loop do
      display_board
      loop do
        play_a_round
        break if game_is_won?
        reset_round
      end
      display_game_result
      break unless play_again?
      reset_game
      display_play_again_message
    end
    display_goodbye_message
  end

  private

  attr_reader :board, :human, :computer, :score

  def play_a_round
    loop do
      current_player_moves
      break if board.someone_won? || board.full?

      clear_screen_and_display_board if human_turn?
    end

    display_round_result
    store_winner
    display_round_stats
    wait_for_player_to_continue unless game_is_won?
  end

  def start_game
    display_welcome_message
    set_markers
    puts
    score.set_rounds_to_win
    puts
  end

  def wait_for_player_to_continue
    puts "Type any key to continue..."
    gets
    puts
  end

  def game_is_won?
    score.game_over?
  end

  def store_winner
    score << winning_player
  end

  def winning_player
    if human_won?
      human
    elsif computer_won?
      computer
    else
      nil
    end
  end

  def human_won?
    human.marker == board.winning_marker
  end

  def computer_won?
    computer.marker == board.winning_marker
  end

  def display_round_stats
    score.display_round_stats
  end

  def set_markers
    human.pick_marker(MARKERS)
    possible_markers = MARKERS.reject { |mk| mk == human.marker }
    computer.pick_marker(possible_markers)
  end

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

  def change_starting_player
    if @first_to_move == @human
      @first_to_move = @computer
    else
      @first_to_move = @human
    end
  end

  def reset_game
    reset_round
    score.reset
  end

  def reset_round
    board.reset
    change_starting_player
    clear_screen_and_display_board
  end

  def human_moves
    square = nil
    loop do
      puts "Please choose a square from #{board.join_unmarked_squares}:"
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

  def display_result(message)
    if human_won? || computer_won?
      puts "#{winning_player.name} #{message}"
    else
      puts 'It is a tie!'
    end
  end

  def display_game_result
    puts
    display_result('wins the whole game')
    puts
  end

  def display_round_result
    clear_screen_and_display_board
    display_result('wins the round')
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
    score.display_round
    puts "#{human.name} is #{human.marker}, #{computer.name} is #{computer.marker}"
    puts
    board.draw
    puts
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_welcome_message
    puts
    puts "Hello #{human.name} and welcome to Tic Tac Toe!"
    puts "My name is #{computer.name} and I will be your opponent"
    puts
  end

  def display_goodbye_message
    puts 'Thank you for playing Tic Tac Toe! Goodbye!'
  end
end

game = TTTGame.new
game.play
