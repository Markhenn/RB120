Tic Tac Toe is a 2-player board game played on a 3x3 grid. Players take turns
marking a square. The first player to mark 3 squares in a row wins.

# Basic end stuff
- rubocop
- organize methods in a better fashion for someone to read through

# Update player chooses move
0. add an array of robot classes to computer and go through it when setting
   oponent
   a) change @easy to dificulty 
1. move human_move into Human class
2. move simple computer_move into C3PO
3. move minimax into R2D2
4. create extra class for minimax
5. try to turn minimax into a procedural method
6. create medium computer -> add wall e as robot back

# update computers
- find a way to get a list with computer classes
- use this array for letting the player choose whom to play

# Add on minimax
- let player decide the strength of computer
- set easy to true or false on set up
- prepare to not ask if field is bigger than 3x3

- maybe add choosing strategy to computer and human class
> - let the player decide which computer to player

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


