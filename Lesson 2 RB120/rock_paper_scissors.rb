# Game of rock, paper & scissors

class MoveHistory
  def initialize
    @moves = []
  end

  def add_move(move)
    @moves << move
  end

  def to_s
    @moves.each_with_index do |move, idx|
      print "#{idx + 1}. #{move} "
    end
    puts
  end
end

class Score
  @@win_to_end = nil

  def initialize
    @wins = 0
  end

  def self.wins_to_end
    @@wins_to_end
  end

  def self.wins_to_end=(number)
    @@wins_to_end = number
  end

  def add_win
    @wins += 1
  end

  def game_over?
    @wins >= @@wins_to_end
  end

  def to_s
    @wins.to_s
  end
end

class Move
  VALUES = %w(rock paper scissors lizard spock).freeze

  def self.set(choice)
    case choice
    when 'rock' then Rock.new
    when 'paper' then Paper.new
    when 'scissors' then Scissors.new
    when 'spock' then Spock.new
    when 'lizard' then Lizard.new
    end
  end
end

class Rock < Move
  def to_s
    "Rock"
  end

  def >(other_move)
    other_move.class == Scissors ||
      other_move.class == Lizard
  end
end

class Scissors < Move
  def to_s
    "Scissors"
  end

  def >(other_move)
    other_move.class == Paper ||
      other_move.class == Lizard
  end
end

class Paper < Move
  def to_s
    "Paper"
  end

  def >(other_move)
    other_move.class == Spock ||
      other_move.class == Rock
  end
end

class Spock < Move
  def to_s
    "Spock"
  end

  def >(other_move)
    other_move.class == Scissors ||
      other_move.class == Rock
  end
end

class Lizard < Move
  def to_s
    "Lizard"
  end

  def >(other_move)
    other_move.class == Spock ||
      other_move.class == Paper
  end
end

class Player
  attr_accessor :name
  attr_reader :score, :move, :history

  def initialize
    set_name
    @score = Score.new
    @history = MoveHistory.new
  end

  def move=(move)
    @move = move
    @history.add_move(move)
  end

  def reset_score
    @score = Score.new
    @history = MoveHistory.new
  end
end

class Human < Player
  def choose
    choice = nil
    choices = "#{Move::VALUES[0..-2].join(', ')} or #{Move::VALUES[-1]}"
    puts "Please choose a move: #{choices}:"
    loop do
      choice = gets.chomp.downcase
      break if Move::VALUES.include? choice
      puts "Please type one of the following moves: #{choices}:"
    end
    self.move = Move.set(choice)
  end

  def set_name
    n = nil
    loop do
      puts "Hello! What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Please tell me your name!"
    end
    self.name = n
  end
end

class Computer < Player
  ROBOTS = {
    'R2D2' => Move::VALUES,
    'C3PO' => [
      ['rock'] * 1,
      ['paper'] * 8,
      ['scissors'] * 3,
      ['lizard'] * 3,
      ['spock'] * 10
    ].flatten,
    'The Terminator' => [
      ['rock'] * 5,
      ['scissors'] * 3,
      ['lizard'] * 2,
      ['spock'] * 1
    ].flatten,
    'Wall-e' => [
      ['rock'] * 3,
      ['paper'] * 3,
      ['scissors'] * 2,
      ['lizard'] * 8,
      ['spock'] * 5
    ].flatten
  }

  def choose
    self.move = Move.set(ROBOTS[name].sample)
  end

  def set_name
    self.name = ROBOTS.keys.sample
  end

  def greet
    case name
    when 'R2D2'
      puts 'R2D2 says: Beeep, beep, beep, beeeeeep!'
    when 'C3PO'
      puts 'Hello Sir, I am C3PO and I am your opponent'
    when 'The Terminator'
      puts 'I am the Terminator and came to DESTROY you!'
    when 'Wall-e'
      puts 'Wall-e likes you and wants to play!'
    end
  end
end

# Game orchestration Engine

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
    @winner = nil
    @wins = nil
  end

  def display_welcome_message
    puts
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock!"
    computer.greet
    puts
  end

  def choose_rounds_to_win
    puts 'How many rounds should a player win to win the whole match?'
    puts 'Please give a number from 1 to 10.'
    number = nil
    loop do
      number = gets.chomp
      break if in_range?(number)
      puts 'Please type a number from 1 to 10!'
    end
    Score.wins_to_end = number.to_i
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
    puts
  end

  def show_move_history
    puts "#{human.name} played the following moves:"
    human.history.to_s
    puts "#{computer.name} played these moves:"
    computer.history.to_s
  end

  def determine_winner
    @winner = if human.move > computer.move
                human
              elsif computer.move > human.move
                computer
              end
  end

  def update_scores
    @winner.score.add_win unless @winner.nil?
  end

  def display_winner
    return puts "It's a tie" if @winner.nil?
    puts "#{@winner.name} wins!"
  end

  def display_scores
    puts "A player needs #{Score.wins_to_end} wins to win the macht!"
    puts "#{human.name} has #{human.score} wins."
    puts "#{computer.name} has #{computer.score} wins."
    puts
  end

  def player_won?
    human.score.game_over? || computer.score.game_over?
  end

  def display_final_winner
    puts
    puts "#{@winner.name} wins the game!"
    puts
  end

  def reset_scores
    human.reset_score
    computer.reset_score
  end

  def display_goodbye_message
    puts "Thank you for playing Rock, Paper, Scissors, Lizard, Spock! Good Bye."
  end

  def play_again?
    puts "Type y to play #{computer.name} again, anything else to end the game!"
    answer = gets.chomp.downcase

    return true if answer == 'y'
    false
  end

  def play_a_round
    human.choose
    computer.choose
    display_moves
    determine_winner
    update_scores
    display_winner
    display_scores
  end

  def play
    display_welcome_message
    choose_rounds_to_win
    loop do
      loop do
        play_a_round
        break if player_won?
      end
      show_move_history
      display_final_winner
      reset_scores
      break unless play_again?
    end
    display_goodbye_message
  end

  private

  def in_range?(number)
    number.to_i > 0 && number.to_i <= 10
  end

  # def integer?(number)
  #   number == number.to_i.to_s
  # end
end

RPSGame.new.play
