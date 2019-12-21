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
  VALUES = {
    'r'  => { wins: ['sc', 'l'], name: 'Rock' },
    'p'  => { wins: ['r', 'sp'], name: 'Paper' },
    'sc' => { wins: ['p', 'l'], name: 'Scissors' },
    'l'  => { wins: ['sp', 'p'], name: 'Lizard' },
    'sp' => { wins: ['r', 'sc'], name: 'Spock' }
  }

  attr_reader :move

  def initialize(value)
    @move = value
  end

  def to_s
    VALUES[move][:name]
  end

  def >(other_move)
    VALUES[move][:wins].include?(other_move.move)
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
    choices = "(r)ock, (p)aper, (sc)issors, (l)izard or (sp)ock"
    puts "To choose a move type the chars in (): #{choices}:"
    loop do
      choice = gets.chomp.downcase
      break if Move::VALUES.keys.include? choice
      puts "Please type chars like 'r' for rock or 'sp' for spock: #{choices}:"
    end
    self.move = Move.new(choice)
  end

  private

  def set_name
    n = nil
    loop do
      puts "Hello! What's your name?"
      n = gets.chomp
      break unless n.empty? || n.start_with?(' ')
      puts "Please tell me your name!"
    end
    self.name = n
  end
end

class Computer < Player
  def choose
    self.move = Move.new(moves.sample)
  end

  def greet
    puts self
  end
end

class R2D2 < Computer
  def moves
    Move::VALUES.keys
  end

  def set_name
    self.name = 'R2D2'
  end

  def to_s
    'R2D2 says: Beeep, beep, beep, beeeeeep!'
  end
end

class C3PO < Computer
  def moves
    [['r'] * 1, ['p'] * 8, ['sc'] * 3, ['l'] * 3, ['sp'] * 10].flatten
  end

  def set_name
    self.name = 'C3PO'
  end

  def to_s
    'Hello Sir, I am C3PO and I am your opponent'
  end
end

class Terminator < Computer
  def moves
    [['r'] * 5, ['sc'] * 3, ['l'] * 2, ['sp'] * 1].flatten
  end

  def set_name
    self.name = 'The Terminator'
  end

  def to_s
    'I am the Terminator and came to DESTROY you!'
  end
end

class WallE < Computer
  def moves
    [['r'] * 3, ['p'] * 3, ['sc'] * 2, ['l'] * 8, ['sp'] * 5].flatten
  end

  def set_name
    self.name = 'Wall-e'
  end

  def to_s
    'Wall-e likes you and wants to play!'
  end
end

# Game orchestration Engine

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = [R2D2.new, C3PO.new, Terminator.new, WallE.new].sample
    @winner = nil
    @wins = nil
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
    system('clear') || system('cls')
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
    @winner.score.add_win if @winner
  end

  def display_winner
    winner = @winner ? "#{@winner.name} wins!" : "It's a tie!"
    puts winner
  end

  def display_scores
    puts "A player needs #{Score.wins_to_end} wins to win the match!"
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
    system('clear') || system('cls')

    answer == 'y'
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

  def in_range?(number)
    number.to_i > 0 && number.to_i <= 10
  end
end

RPSGame.new.play
