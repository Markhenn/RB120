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
      break if ['rock', 'paper', 'scissors'].include? choice
      puts 'Invalid choice!'
    end
    self.move = choice
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
    self.move = ['rock', 'paper', 'scissors'].sample
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

  def display_winner
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."

    case human.move
    when 'rock'
      puts "#{human.name} win!" if computer.move == 'scissors'
      puts "#{computer.name} wins!" if computer.move == 'paper'
      puts "It is a tie" if computer.move == 'rock'
    when 'paper'
      puts "#{human.name} win!" if computer.move == 'rock'
      puts "#{computer.name} wins!" if computer.move == 'scissors'
      puts "It is a tie" if computer.move == 'paper'
    when 'scissors'
      puts "#{human.name} win!" if computer.move == 'paper'
      puts "#{computer.name} wins!" if computer.move == 'rock'
      puts "It is a tie" if computer.move == 'scissors'
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
  
  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      display_winner
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
