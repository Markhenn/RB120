# Tic Tac Toe Game

class Board
  DELIMITER = ','
  END_DELIM = 'or'

  attr_reader :width

  def initialize(width)
    @squares = {}
    @width = width
    reset
    @winning_lines = calculate_winning_lines
  end

  def []=(square_num, marker)
    squares[square_num].marker = marker
  end

  def middle_square
    middle_point = (width**2).to_f / 2
    squares[middle_point.ceil]
  end

  def get_squares(unmarked: true)
    if unmarked
      squares.select { |_, sq| sq.unmarked? }
    else
      squares.reject { |_, sq| sq.unmarked? }
    end
  end

  def unmarked_random_square
    get_squares(unmarked: true).values.sample
  end

  def unmarked_square_keys
    get_squares(unmarked: true).keys
  end

  def join_unmarked_square_keys
    joinor(unmarked_square_keys)
  end

  def full?
    get_squares(unmarked: true).empty?
  end

  def someone_won?
    !!winning_marker
  end

  def draw
    brd_array = []
    brd_values = squares.values
    brd_numbers = squares.keys

    1.upto(width) { brd_array << brd_values.shift(width) }

    brd_array.each_with_index do |line, index|
      display_squares(line, index, brd_numbers)
    end
  end

  def reset
    board_size = width**2
    (1..board_size).each { |key| squares[key] = Square.new }
  end

  def winning_marker
    winning_lines.each do |line|
      next if squares[line.first].unmarked?

      return marker_at(line.first) if three_in_a_line(line)
    end
    nil
  end

  def squares_in_winning_line
    winning_lines.map do |line|
      squares.values_at(*line)
    end
  end

  def copy
    new_board = Board.new(width)
    squares.each { |sq, mk| new_board.squares[sq] = mk.clone }
    new_board
  end

  protected

  attr_reader :squares

  private

  attr_reader :winning_lines

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

  # Section: Display the Board
  def display_empty_square
    1.upto(width) do |count|
      if count != width
        print "     |"
      end
    end
    puts ""
  end

  def display_divider(row_idx)
    if row_idx < width - 1
      1.upto(width) do |count|
        if count == width
          puts "-----"
        else
          print "-----+"
        end
      end
    else
      puts ""
    end
  end

  def display_squares(array, row_idx, brd_numbers)
    line_numbers = brd_numbers.shift(width).join(", ")

    display_empty_square

    array.each_with_index do |square, idx|
      if idx == width - 1
        print "  #{square}   \##{line_numbers}"
      else
        print "  #{square}  |"
      end
    end

    puts
    display_empty_square
    display_divider(row_idx)
  end

  # Section: Winning Lines
  def calculate_rows
    rows = squares.keys
    winning_rows = []

    width.times { winning_rows << rows.shift(width) }
    winning_rows
  end

  def calculate_columns
    columns = Array.new(width, [])

    columns.map.with_index do |_, idx|
      (idx + 1).step(by: width, to: squares.size).to_a
    end
  end

  def calculate_diagonals
    size = squares.size
    diagonals = []

    diagonals << 1.step(by: width + 1, to: size).to_a
    diagonals << width.step(by: width - 1, to: size - width + 1).to_a
  end

  def calculate_winning_lines
    rows = calculate_rows
    columns = calculate_columns
    diagonals = calculate_diagonals

    rows + columns + diagonals
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
      puts
    end
    puts

    @marker = answer
  end

  def move(board)
    square = nil
    loop do
      puts "Please choose a square from #{board.join_unmarked_square_keys}:"
      square = gets.chomp.to_i
      break if board.unmarked_square_keys.include?(square)

      puts "Sorry! Invalid choice"
      puts
    end
    puts

    board[square] = marker
  end

  private

  def set_name
    answer = nil
    loop do
      puts "Hey what is your name?"
      answer = gets.chomp
      break  if answer.size > 1

      puts "Sorry that is too short, at least 2 letters please!"
      puts
    end
    puts

    answer
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
  ROBOT_CALC_LIMIT = 9
  WIN = 1
  LOSE = -1
  TIE = 0
  NAME_IDX = %w(r2d2 r2 r)

  def self.index
    NAME_IDX
  end

  def self.message
    'R2D2 - the unbeatable! Beep Beeeeep!'
  end

  def move(brd)
    self.board = brd
    self.human_marker = determine_human_marker

    calculate_square.marker = marker
  end

  def play_again_message
    'Beep Beep Beeep! (You will never beat me, but try again if you must!)'
  end

  private

  # Section: Calculate optimal square with minimax algorithm
  def calculate_square
    if board.unmarked_square_keys.size >= ROBOT_CALC_LIMIT
      board.unmarked_random_square
    else
      minimax(board, 0, computer_turn: true)
    end
  end

  def minimax(brd, depth, computer_turn: true)
    if brd.full? || brd.someone_won?
      return terminal_result(brd)
    end

    node_values = calculate_note_values(brd, depth, computer_turn)

    if depth == 0
      return optimal_square(node_values)
    end

    node_result(node_values, computer_turn)
  end

  def calculate_note_values(brd, depth, computer_turn)
    brd.unmarked_square_keys.each_with_object({}) do |square, hash|
      new_brd = brd.copy

      if computer_turn
        new_brd[square] = marker
        hash[square] = minimax(new_brd, depth + 1, computer_turn: false)
      else
        new_brd[square] = human_marker
        hash[square] = minimax(new_brd, depth + 1, computer_turn: true)
      end
    end
  end

  def optimal_square(minimax_values)
    max_value = minimax_values.values.max
    top_squares = minimax_values.each_with_object([]) do |(sq, v), ary|
      ary << sq if v == max_value
    end
    board.get_squares(unmarked: true)[top_squares.sample]
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
    when marker then WIN
    when human_marker then LOSE
    else TIE
    end
  end
end

class C3PO < Computer
  THREAT_SQ = 1
  NAME_IDX = %w(c3po 3po c)

  def self.index
    NAME_IDX
  end

  def self.message
    'C3PO - I am somewhat a challenge.'
  end

  def move(brd)
    self.board = brd
    self.human_marker = determine_human_marker
    good_square.marker = marker
  end

  def play_again_message
    'This has been an extraordinary match! Would like to play again?'
  end

  private

  def good_square
    unless two_marker_in_line.flatten.empty?
      return two_marker_in_line.select(&:unmarked?).first
    end

    if board.middle_square.unmarked?
      return board.middle_square
    end

    board.unmarked_random_square
  end

  def two_marker_in_line
    [marker, human_marker].each_with_object([]) do |mk, ary|
      ary << board.squares_in_winning_line.select do |line|
        line.count(&:unmarked?) == THREAT_SQ &&
          line.count { |sq| sq.marker == mk } == board.width - THREAT_SQ
      end
    end.flatten
  end
end

class WallE < Computer
  NAME_IDX = %w(walle w)

  def self.index
    NAME_IDX
  end

  def self.message
    'Wall-E - I just like to play.'
  end

  def set_name
    'Wall-E'
  end

  def move(brd)
    self.board = brd
    board.unmarked_random_square.marker = marker
  end

  def play_again_message
    'Wall-E wants to play another round with you!'
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

  def display_statistics
    puts
    puts "#{rounds_played} rounds have been played"
    puts "#{rounds_to_win} wins or ties needed to end the game"
    puts
    display_win_counts
    puts
  end

  def game_over?
    round_winner.values.any? { |wins| wins >= @rounds_to_win }
  end

  def <<(winner)
    @round_winner[winner] += 1
  end

  def set_rounds_to_win
    answer = nil
    loop do
      puts "After How many wins or ties should end the game?"
      puts "Choose from 1 and 10 rounds"
      answer = gets.chomp.to_i
      break if (1..10).to_a.include? answer

      puts "Sorry, invalid answer! Type a number from 1 and 10"
      puts
    end
    puts

    @rounds_to_win = answer
  end

  private

  attr_reader :round_winner, :rounds_to_win

  def only_ties?
    round_winner.keys.all?(&:nil?)
  end

  def display_win_counts
    round_winner.each do |winner, count|
      next puts "#{count} ties so far" if winner.nil?
      puts "#{winner.name} won #{count} rounds"
    end
  end

  def rounds_played
    return 0 if round_winner.empty?
    round_winner.values.reduce(:+)
  end
end

class TTTGame
  MARKERS = ("A".."Z").to_a

  def initialize
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

  # Section: Play a round
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

  def current_player_moves
    if human_turn?
      human.move(board)
      self.current_player = computer
    else
      computer.move(board)
      self.current_player = human
    end
  end

  def human_turn?
    current_player == human
  end

  def display_round_result
    clear_screen_and_display_board
    display_result('wins the round')
  end

  def store_winner
    score << winning_player
  end

  def display_round_stats
    score.display_statistics
  end

  def wait_for_player_to_continue
    puts "Type any key to continue..."
    gets
    puts
  end

  def game_is_won?
    score.game_over?
  end

  def clear
    system 'clear'
  end

  def display_board
    score.display_round
    puts "#{human.name} is #{human.marker}, "\
         "#{computer.name} is #{computer.marker}"
    puts
    board.draw
    puts
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  # Section: Game Set up
  def start_game
    set_board
    set_opponent
    display_welcome_message
    set_markers
    set_game_length
  end

  def set_board
    answer = nil
    loop do
      puts "Which board size would like to play on?"
      puts "Type 3 for 3x3 (standard tictactoe board size)"
      puts "Type 5 for 5x5"
      answer = gets.chomp.to_i
      break if [3, 5].include?(answer)

      puts 'Not a valid choice!'
      puts
    end
    puts

    @board = Board.new(answer)
  end

  def set_opponent
    answer = nil
    puts "Who shall be your opponent?"

    loop do
      puts "Pick one of the robots by typing the first letter of his name:"
      print robot_messages
      answer = gets.chomp.downcase
      break if all_robots.include? answer

      puts "Sorry invalid input!"
      puts
    end
    puts

    assign_robot(answer)
  end

  def all_robots
    robots = Array.new
    robots += R2D2.index unless board.width > 3
    robots + C3PO.index + WallE.index
  end

  def assign_robot(answer)
    @computer = if R2D2.index.include? answer
                  R2D2.new
                elsif C3PO.index.include? answer
                  C3PO.new
                elsif WallE.index.include? answer
                  WallE.new
                end
  end

  def robot_messages
    puts R2D2.message unless board.width > 3
    puts C3PO.message
    puts WallE.message
  end

  def display_welcome_message
    puts "Hello #{human.name} and welcome to Tic Tac Toe!"
    puts "My name is #{computer.name} and I will be your opponent"
    puts
    puts 'To make the game more fun I will set the following house rules:'
    puts '1. You will place your marker first in round 1.'
    puts '2. In round 2 I will place my marker first.'
    puts '3. In a rematch the loosing player will place his marker first.'
    puts
  end

  def set_markers
    human.pick_marker(MARKERS)
    possible_markers = MARKERS.reject { |mk| mk == human.marker }
    computer.pick_marker(possible_markers)
  end

  def set_game_length
    score.set_rounds_to_win
  end

  # Section: Round or Game Over
  def winning_player
    if human_won?
      human
    elsif computer_won?
      computer
    end
  end

  def human_won?
    human.marker == board.winning_marker
  end

  def computer_won?
    computer.marker == board.winning_marker
  end

  def display_play_again_message
    puts "Let's play again!"
    puts
  end

  def change_starting_player
    @first_to_move = if first_to_move == human
                       computer
                     else
                       human
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

  def display_result(message)
    if human_won? || computer_won?
      puts "#{winning_player.name} #{message}"
    else
      puts 'It is a tie!'
    end
    puts
  end

  def display_game_result
    puts '*****************************'
    puts 'The game is over!'
    display_result('wins the whole game')
    puts '*****************************'
    puts
    score.display_statistics
  end

  def play_again?
    puts computer.play_again_message
    puts
    puts "Type y if you want to play #{computer.name} again"
    answer = gets.chomp.downcase
    clear

    answer.start_with? 'y'
  end

  def display_goodbye_message
    puts 'Thank you for playing Tic Tac Toe! Goodbye!'
  end
end

game = TTTGame.new
game.play
