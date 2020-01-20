Tic Tac Toe is a 2-player board game played on a 3x3 grid. Players take turns
marking a square. The first player to mark 3 squares in a row wins.

# Basic end stuff
- go over hardcoded values and change to constants or states
- go over all methods and delete the unneeded ones
- go over methods and look commonalities and ways to simpify them
- rubocop
- organize methods in a better fashion for someone to read through
- create a different play again message for each robot

# Update player chooses move
3. move minimax into R2D2
4. create extra class for minimax
5. try to turn minimax into a procedural method
- change 3po to use the computer and update methods

# Add on minimax
- prepare to not ask if field is bigger than 3x3


## create a minimax class
- when looking for the optimal square call minimax.new(board).square
- the class instantiates with board variable 
- need to instantiate with the computer marker
- square will start the calculation
  - during calculation a new minimax object will be created with a new board
    copy
  - initialize if it is the computer or player turn
  - initialize depth to zero default
  - find a way to check up on markers without user Players a collaborative
    object
  - 

# Add bigger boards
- let the player decide to play a 5x5 board

