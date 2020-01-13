Tic Tac Toe is a 2-player board game played on a 3x3 grid. Players take turns
marking a square. The first player to mark 3 squares in a row wins.

# Keep score

Keep score of how many times the player and computer each win. Don't use global or instance variables. Make it so that the first player to 5 wins the game.

## Problem
keep score for each player and terminate after a set amount of wins (5)

check after each round if some has won the game then terminate to ask for
another game

print the game stats after each round

Tell who won the whole game at the end -> which you can keep the way it works
right now, because the winner will have won the last round -> so no reset after
the last win

## Test cases
use game to test feature

## Data Structure
use an array in TTTGame
> - the array stores the winning mark or nil at a tie

## Algorithm
test for game won
> - count the occurences of the marker in the array
> - when on is the set number -> terminate

update to game
> - after winner is found -> store mark in round_winner array
> - alternate game starter each round
> - add round counter to display board

method to decide rounds to play
- ask player how many rounds to play
- make sure it is an int between 1 and 10
- save that to an instance variable in TTTGame

display round stats
> - display rounds played
> - display wins need
> - display wins of each player

## Extras
- make the end game result message more beatiful
- skip wait_for_player if game is over
- create Score class and put everything needed to keep score in there
  - round_winner, wins needed, game over? etc
