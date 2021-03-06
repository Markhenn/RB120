# Create an object-oriented number guessing class for numbers in the range 1 to 100, with a limit of 7 guesses per game. The game should play like this:
#
# Problem
# Create class that starts a number guessing game
# player puts number between 1-100
#   if invalid -> write that
#   if correct -> win
#   check if higher or lower than number -> return hint
#
#   The player can guess 7 times -> then lose
#
#   Data Structure
#   instance variables:
#   - number to guess
#   - counter
#
#   methods
#   - play
#   - create random number from 1-100
#   - check guess against number
#   - input guess
#   - update counter
#
#   Algorithm
#   play method
#   create random number
#   set number of guesses
#   loop until guesses reach 0
#     loop
#       ask for guess
#       validate
#     end
#
#     check guess against number
#     return if won
#     update counter
#   end

class GuessingGame
  def initialize(low, high)
    @number = nil
    @range = low..high
    @guesses = Math.log2(high - low).to_i + 1
  end

  def play
    reset
    play_game
    display_result
  end

  private

  def reset
    @number = rand(@range)
  end

  def play_game
    @guesses.downto(1) do |round|
      guess = 0
      display_guesses_left
      loop do
        print 'Enter a number between 1 and 100: '
        guess = gets.chomp.to_i
        break if (1..100).cover?(guess)
        print 'Invalid guess. '
      end

      break if game_won?(guess)

      give_hint(guess)
      @guesses -= 1
    end
  end

  def display_guesses_left
    if @guesses == 1
      puts 'You have 1 guess left!'
    else
      puts "You have #{@guesses} guesses remaining."
    end
  end

  def game_won?(guess)
    guess == @number
  end

  def give_hint(guess)
    hint = guess > @number ? 'high' : 'low'
    puts "Your guess is too #{hint}"
    puts
  end

  def display_result
    if @guesses > 0
      puts "That's the number!"
      puts
      puts "You won!"
    else
      puts 'You have no more guesses. You lost!'
    end
  end
end
game = GuessingGame.new(1, 100)
game.play
