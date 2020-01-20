# Tic Tac Toe Game

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                   [1, 4, 7], [2, 5, 8], [3, 6, 9],
                   [1, 5, 9], [3, 5, 7]]

  DELIMITER = ','
  END_DELIM = 'or'

  WIDTH = 3

  attr_reader :width

  def initialize
    @squares = {}
    reset
    @width = WIDTH
  end

  def []=(square_num, marker)
    squares[square_num].marker = marker
  end

  def middle_square
    middle_point = (width ** 2).to_f / 2
    middle_point.ceil
  end

  def get_squares(unmarked: true)
    if unmarked
      squares.select { |_, sq| sq.unmarked? }
    else
      squares.reject { |_, sq| sq.unmarked? }
    end
  end

  def unmarked_random_square
    unmarked_square_keys.sample
  end

  def unmarked_square_keys
    get_squares(unmarked: true).keys
  end


  def join_unmarked_square_keys
    joinor(self.unmarked_square_keys)
  end

  def full?
    get_squares(unmarked: true).empty?
  end

  def someone_won?
    !!winning_marker
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{squares[1]}  |  #{squares[2]}  |  #{squares[3]}"
    puts "     |     |"
    puts " ----+-----+-----"
    puts "     |     |"
    puts "  #{squares[4]}  |  #{squares[5]}  |  #{squares[6]}"
    puts "     |     |"
    puts " ----+-----+-----"
    puts "     |     |"
    puts "  #{squares[7]}  |  #{squares[8]}  |  #{squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize

  def reset
    (1..9).each { |key| squares[key] = Square.new }
  end

  def winning_marker
    WINNING_LINES.each do |line|
      next if squares[line.first].unmarked?

      return marker_at(line.first) if three_in_a_line(line)
    end
    nil
  end

  def squares_in_line_back_up
    WINNING_LINES.map do |line|
      squares.values_at(*line)
    end
  end

  def squares_in_line
    WINNING_LINES.map do |line|
      squares.select do |num, _|
        line.include? num
      end
    end
  end

  def copy
    new_board = Board.new
    squares.each { |sq, mk| new_board.squares[sq] = mk.clone }
    new_board
  end

  protected

  attr_reader :squares

  private

  attr_writer :width

  def three_in_a_line(line)
    squares.values_at(*line[1..-1]).map(&:marker).all? do |mk|
      mk == marker_at(line.first)
    end
  end

  def marker_at(square)
    squares[square].marker
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

  def move(board)
    square = nil
    loop do
      puts "Please choose a square from #{board.join_unmarked_square_keys}:"
      square = gets.chomp.to_i
      break if board.unmarked_square_keys.include?(square)
      puts "Sorry! Invalid choice"
    end

    board[square] = marker
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
  FIXED_MARKER = '+'

  def pick_marker(markers)
    @marker = markers.sample
  end

  private

  attr_accessor :board, :human_marker

  def set_name
    self.class
  end

  def determine_human_marker
    human_squares = board.get_squares(unmarked: false).values.reject do |sq|
                      sq.marker == marker
                   end

    return human_squares.first.marker unless human_squares.empty?

    FIXED_MARKER
  end
end

class R2D2 < Computer
  def move(brd)
    self.board = brd
    self.human_marker = determine_human_marker
    optimal_square = minimax(board, 0, computer_turn: true)
    p optimal_square
    board[optimal_square] = marker
  end

  def self.message
    'the unbeatable! Beep Beeeeep!'
  end

  # rubocop:disable Metrics/MethodLength
  def minimax(brd, depth, computer_turn: true)
    if brd.full? || brd.someone_won?
      return terminal_result(brd)
    end

    minimax_values = brd.unmarked_square_keys.each_with_object({}) do |square, hash|
      new_brd = brd.copy

      require 'pry'; binding.pry
      if computer_turn
        new_brd[square] = marker
        hash[square] = minimax(new_brd, depth + 1, computer_turn: false)
      else
        new_brd[square] = human_marker
        hash[square] = minimax(new_brd, depth + 1, computer_turn: true)
      end
    end

    if depth == 0
      return optimal_square(minimax_values)
    end

    node_result(minimax_values, computer_turn)
  end
  # rubocop:enable Metrics/MethodLength,

  def optimal_square(minimax_values)
    max_value = minimax_values.values.max
    top_squares = minimax_values.each_with_object([]) do |(sq, v), ary|
      ary << sq if v == max_value
    end
    top_squares.sample
  end

  def node_result(minimax_values, computer_turn)
    if computer_turn
      minimax_values.values.max
    else
      minimax_values.values.min
    end
  end

  def terminal_result(brd)
    case brd.winning_marker
    when marker then  1
    when human_marker   then -1
    else 0
    end
  end
end

class C3PO < Computer
  def self.message
    'somewhat a challenge.'
  end

  def move(brd)
    self.board = brd
    self.human_marker = determine_human_marker
    board[good_square] = marker
  end

  private

  def good_square
    unless two_marker_in_line.flatten.empty?
      unmarked = two_marker_in_line.flatten.first.select do |_, sq|
                   sq.unmarked?
                 end
      return unmarked.keys.first
    end

    if board.unmarked_square_keys.include? board.middle_square
      return board.middle_square
    end

    board.unmarked_random_square
  end

  def two_marker_in_line
    [marker, human_marker].each_with_object([]) do |mk, ary|
      ary << board.squares_in_line.select do |line|
               line.values.count { |sq| sq.unmarked? } == 1 &&
                 line.values.count { |sq| sq.marker == mk } == board.width - 1
             end
    end
  end
end

class WallE < Computer
  def self.message
    'just likes to play.'
  end

  def move(brd)
    self.board = brd
    board[board.unmarked_random_square] = marker
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
    puts "#{@rounds_to_win} wins or ties needed to end the game"
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

  attr_reader :board, :human, :computer, :score, :first_to_move
  attr_accessor :current_player

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
    puts
    set_opponent
    display_welcome_message
    set_markers
    puts
    score.set_rounds_to_win
    puts
  end

  def set_opponent
    answer = nil
    puts "Who shall be your opponent?"

    loop do
      puts "Pick one of the following by typing the first letter of his name:"
      puts "1. #{R2D2} #{R2D2.message}"
      puts "2. #{C3PO} #{C3PO.message}"
      puts "3. #{WallE} #{WallE.message}"
      answer = gets.chomp.downcase
      break if %w(w walle 3 r c 1 2 r2d2 c3po r2 3po).include? answer

      puts "Sorry invalid input!"
    end

    @computer = R2D2.new if %w(r 1 r2d2 r2).include? answer
    @computer = C3PO.new if %w(c 2 c3po 3po).include? answer
    @computer = WallE.new if %w(w 3 walle).include? answer
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
    current_player == human
  end

  def current_player_moves
    if human_turn?
      human.move(board)
      self.current_player = computer
    else
      computer.move(board)
      self.current_player = human
    end
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end

  def change_starting_player
    if first_to_move == human
      first_to_move = computer
    else
      first_to_move = human
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

  # rubocop:disable Metrics/MethodLength
  def minimax(brd, depth, computer_turn)
    if brd.full? || brd.someone_won?
      return terminal_result(brd)
    end

    minimax_values = brd.unmarked_square_keys.each_with_object({}) do |square, hash|
      new_brd = brd.copy

      if computer_turn
        new_brd[square] = computer.marker
        hash[square] = minimax(new_brd, depth + 1, false)
      else
        new_brd[square] = human.marker
        hash[square] = minimax(new_brd, depth + 1, true)
      end
    end

    if depth == 0
      return optimal_square(minimax_values)
    end

    node_result(minimax_values, computer_turn)
  end
  # rubocop:enable Metrics/MethodLength,

  def optimal_square(brd_values)
    max_value = brd_values.values.max
    top_squares = brd_values.each_with_object([]) do |(sq, v), ary|
      ary << sq if v == max_value
    end
    top_squares.sample
  end

  def node_result(brd_values, computer_turn)
    if computer_turn
      brd_values.values.max
    else
      brd_values.values.min
    end
  end

  def terminal_result(brd)
    case brd.winning_marker
    when computer.marker then  1
    when human.marker   then -1
    else 0
    end
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
