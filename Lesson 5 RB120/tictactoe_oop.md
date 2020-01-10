Tic Tac Toe is a 2-player board game played on a 3x3 grid. Players take turns
marking a square. The first player to mark 3 squares in a row wins.

# Player can pick any marker
- The player can pick any marker at the beginning of the game
- this means he decides what sign his marker can have

- edge cases:
  - only let a capitalized letter count
  - no extra letter or numbers
  - only 1 letter
  - can input upper or lower case
  - cant input no letter
  - Should he choose X the computer will choose O

## Test cases
- test with the life game

## Data Structure
- add to Player class
- a marker array with all markers -> make it a class variable
- subclasses for computer and human
- a method called pick_marker for each sublcass

## Algorithm
- When game starts the human can pick the marker
- call it pick markers in the Player initialize method for @marker
  - pick marker works differently for the computer and the human
  - if human.marker is X -> set computer marker to O
  

pick_marker
- intro text marker needs to be a letter from a-z
- get letter and upcase
- break if it is a single letter
- set letter as marker
- delete letter from markers array

- computer picks a random marker from the remaind markers array
