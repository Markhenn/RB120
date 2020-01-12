Tic Tac Toe is a 2-player board game played on a 3x3 grid. Players take turns
marking a square. The first player to mark 3 squares in a row wins.

# Improved join

Currently, we're using the Array#join method, which can only insert a delimiter between the array elements, and isn't smart enough to display a joining word for the last element.

Write a method called joinor that will produce the following result:

joinor([1, 2])                   # => "1 or 2"
joinor([1, 2, 3])                # => "1, 2, or 3"
joinor([1, 2, 3], '; ')          # => "1; 2; or 3"
joinor([1, 2, 3], ', ', 'and')   # => "1, 2, and 3"
Then, use this method in the TTT game when prompting the user to mark a square.

## Problem
Join the numbers in a way that is better to read for a human
Input: array
Output: string

when size of array is two join on 'or' or parameter 3
when size bigger than join on ',' or param 2 for all but the last two which use
the above

## Test Cases
use game

## Data Structure
add method to TTTGame class -> add to private
be called by human_moves

## Algorithm
Take the last two items and join them with needed word
  add a space after and before the joining word
if size more than 2
Take the first items until the last two and join them on the ','
return a string with first part and second part joined by ','
