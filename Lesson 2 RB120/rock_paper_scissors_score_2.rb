# Game of rock, paper & scissors

class Score
  WINS = 1

  def initialize
    @wins = 0
  end

  def add_win
    @wins += 1
  end

  def game_over?
    @wins >= WINS
  end

  def to_s
    @wins.to_s
  end
end

class Move
  VALUES = %w(rock paper scissors).freeze

  def initialize(value)
    @value = value
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def scissors?
    @value == 'scissors'
  end

  def to_s
    @value
  end

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (paper? && other_move.rock?) ||
      (scissors? && other_move.paper?)
  end
end

class Player
  attr_accessor :move, :name
  attr_reader :score

  def initialize
    set_name
    @score = Score.new
  end

  def reset_score
    @score = Score.new
  end
end

class Human < Player
  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper or scissors:"
      choice = gets.chomp
      break if Move::VALUES.include? choice
      puts 'Invalid choice!'
    end
    self.move = Move.new(choice)
  end

  def set_name
    n = nil
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Please tell me your name!"
    end
    self.name = n
  end
end

class Computer < Player
  def choose
    self.move = Move.new(Move::VALUES.sample)
  end

  def set_name
    self.name = %w(R2D2 C3PO BB8 Wall-e).sample
  end
end

# Game orchestration Engine

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def determine_winner
    if human.move > computer.move
      human
    elsif computer.move > human.move
      computer
    end
  end

  def update_scores(winner)
    winner.score.add_win unless winner.nil?
  end

  def display_winner(winner)
    return puts "It's a tie" if winner.nil?
    puts "#{winner.name} wins!"
  end

  def display_scores
    puts "#{human.name} has #{human.score} wins."
    puts "#{computer.name} has #{computer.score} wins."
  end

  def player_won?
    human.score.game_over? || computer.score.game_over?
  end

  def display_final_winner
    winner = human.score.game_over? ? human : computer
    puts "#{winner.name} wins!"
  end

  def reset_scores
    human.reset_score
    computer.reset_score
  end

  def display_goodbye_message
    puts "Thank you for playing Rock, Paper, Scissors!"
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? y or n?"
      answer = gets.chomp
      break if %w(y n).include? answer.downcase
      puts "Answer must be y or n!"
    end

    return true if answer == 'y'
    false
  end

  def play_a_round
    human.choose
    computer.choose
    display_moves
    winner = determine_winner
    update_scores(winner)
    display_winner(winner)
    display_scores
  end

  def play
    display_welcome_message
    loop do
      loop do
        play_a_round
        break if player_won?
      end
      display_final_winner
      reset_scores
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
