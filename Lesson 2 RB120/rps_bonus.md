# RPS Bonus Features
Below are some ideas for features or additions to our Rock, Paper, Scissors game.

## Keeping score

Right now, the game doesn't have very much dramatic flair. It'll be more interesting if we were playing up to, say, 10 points. Whoever reaches 10 points first wins. Can you build this functionality? We have a new noun -- a score. Is that a new class, or a state of an existing class? You can explore both options and see which one works better.

### Problem
plays to win 10 games
create a new class or add the the score as an existing class

#### state of an existing class
state in RPSGame class

__Test by playing game__

__Data Structure__
add a getter for score
add a custom setter for score
  push the winner to an array or tie
create a show score method and call in play
change break rule to break after x wins for  one side

__This solution makes the RPSGame class very long and bloated__

#### create Score class
CRC Card

class Score
__responsibility__
has winning score needed
has score value
displays score
updates score

__colaborators__
class Player
class RPSGame

## Add Lizard and Spock

This is a variation on the normal Rock Paper Scissors game by adding two more options - Lizard and Spock. The full explanation and rules are here.
http://www.samkass.com/theories/RPSSL.html

### Important rules for lizard spoke
spock defeats rock scissors
lizard defeats spock paper
rock defeats lizard scissors
paper defeats spock rock
scissors defeats paper lizard

#### Problem
have 5 moves instead of 3 moves

What needs to be updated?
rules for which moves wins -> more complex
which moves the player can choose

##### Create a compare moves method with 2 parameters
move_human move_computer

rock_wins?
  @value == rock
  other_move == scissors || lizard

## Add a class for each move

What would happen if we went even further and introduced 5 more classes, one for each move: Rock, Paper, Scissors, Lizard, and Spock. How would the code change? Can you make it work? After you're done, can you talk about whether this was a good design decision? What are the pros/cons?

### CRC Card
-----------------------------------------
Spock             |  super_class Move    |
-----------------------------------------
> instance method | Player
to_s              | Human
                  | Computer

This was a great design decision, becauese before hand my Move class was getting
bloated with a lot of similar methods that helped checking who won the round.
Instead of having so many methods now. The special classes themselves just know
if they won against the other. This reduces the methods and checks needed by a
lot and makes the code easier to understand. We can now check directly if  for
example, Spock beats Rock.

## Keep track of a history of moves

As long as the user doesn't quit, keep track of a history of moves by both the human and computer. What data structure will you reach for? Will you use a new class, or an existing class? What will the display output look like?

### CRC Card
-----------------------------------------
MoveHistory
-----------------------------------------
has a store for moves        | Player
displays all stored moves    | RPSGame
add a move


### What else to update
Player classs with state for history
RPSGame class with displaying move history

## Computer personalities

We have a list of robot names for our Computer class, but other than the name, there's really nothing different about each of them. It'd be interesting to explore how to build different personalities for each robot. For example, R2D2 can always choose "rock". Or, "Hal" can have a very high tendency to choose "scissors", and rarely "rock", but never "paper". You can come up with the rules or personalities for each robot. How would you approach a feature like this?

#### Problem
add a hash to Computer that holds the name and the personality for the robot
The personality is an array of moves. The more often a move occurs in the array
the more likely the robot will pick that move. No occurance means the robot will
never pick the move

#### Methods to change
Computer picking name -> random value vom robot keys
Computer chooses move -> Random value from robot name value array

## Extra Features
DONE let player decide the wins needed to win the game
        - method
        loop asking about a number from 1 to 10
        validate that number as number and in range
        set the number WINS state
DONE - go over all input validation
        - test them out 
        - make sure they dont fail
DONE - add white space to text, to make more readable
DONE let the robot say hello and his name
DONE wins needed to win -> add to score display
DONE resolve all rubocop issues
DONE push to github
DONE get a review

## Input from Code review
### Source Code

The interface of your classes could be better defined. It's better to only make public methods that need to be public - everything else should be private or protected. For example, in the RPSGame class the only method that needs to be public is the play method.
In the update_scores method, you could rely on truthiness and write @winner.score.add_win if @winner. I personally find this easier to read, but I'll let you decide!
In the display_winner method, I find that a conditional statement (instead of the explicit return) would make your logic clearer:
if @winner
  puts "#{@winner.name} wins!"
else
  puts "It's a tie"
end
This could also be refactored using the ternary operator.

Regarding your design choices, I find it interesting that you chose to implement subclasses for the Move class, but not for the Computer class. It's certainly a valid choice and I simply want to invite you to consider the tradeoffs:

In the case of the Move subclasses, the logic for which move wins could easily have been represented otherwise and more succinctly, as a hash for example. It might be worth it to look at a few submitted solutions to compare different approaches.
Interestingly, you made the opposite choice for the Computer subclasses. You used a hash and a conditional statement (in your greet method) to account for the different behaviors instead of relying on polymorphism. Note that this is sometimes considered an anti-pattern.
