# Game of rock, paper & scissors

WINS = 1

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

  def initialize
    set_name
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
    @score = Hash.new(0)
  end

  def update_score(winner)
    @score[winner] += 1
  end

  def display_score
    puts "#{human.name} won #{@score[@human]}"
    puts "#{computer.name} won #{@score[@computer]}"
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_winner
    if human.move > computer.move
      update_score(@human)
      puts "#{human.name} wins!"
    elsif computer.move > human.move
      update_score(@computer)
      puts "#{computer.name} wins!"
    else
      puts "It's a tie"
    end
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

  def display_final_winner
    winner = @score.select { |_, wins| wins >= WINS }
    puts "#{winner.keys.first.name} won the game"
  end

  def game_over?
    @score[@human] >= WINS || @score[@computer] >= WINS
  end

  def reset_score
    @score = Hash.new(0)
  end

  def play
    display_welcome_message
    loop do
      loop do
        human.choose
        computer.choose
        display_moves
        display_winner
        display_score
        break if game_over?
      end
      display_final_winner
      reset_score
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
