# Readme for the OOP version of the twenty one game

## Write a description of the problem and extract major nouns and verbs
- Two Players in the game, a human and the computer
- A deck consisting of 52 cards which are shuffled when the game starts
- Each player draws two cards from the deck
- the human can see his cards, but only the 1 card from the computer
- the human starts the round
  - he can decide to hit or stay
    - hit means draw another card
    - stay means end round 
  - when he goes over 21 a player is bust
- the computer does the same, but has to stay at 17 points
- round ends and winner is displayed

### Nouns
Player, Human, Dealer
  stay, total, busted, hit
Deck
  shuffle, deal
Card
Game
  start game / round

### Verbs
Draw, Stay, start game / round, shuffle


## CRC Cards

------------
TOGAME
Responsibility:
start game
display result

Collaborators:
Player
Deck
Dealer

------------
Participant -> super class of Dealer and Player
Responsibility:
star, total, busted?, hit

Collaborators:
Hand
-----------

Dealer, Player -> subclass of Participant
Responsibility:
play turn

Collaborators:
Hand
------------

Hand -> module
Responsibility:
show_hand

------------

Deck
Responsibility:
shuffle, deal a card, keep track of cards

Collaborators:
Card

-------------
Card
Responsibility:
keep track of suit and value
show suit and value

---------------

## Make your code pretty
- create a set up part
  - the player can decide which dealer to play
    - each dealer has a different round buy in

- each round he wins or looses his buy in
- this is displayed at the end of the round
- he can leave the table and take his money or stay every round

- go over all classes and see if the methods in there make sense or if they need
  different names or go to different places
- check encapsulation
- run rubocop again

## Set up fund system for TO Game
- the player has 10 in the beginning
- after flop he can decided how much he wants to bet
 - the flop only shows him 1 of his cards and 1 of the dealers
- after the round he either wins the amount extra, looses it or stays the same
- he can decide to play another round or leave the table and cash in
- after the game his earnings (win - initial) will be displayed

extra
- choose a dealer
- each dealer has a different min bet


update flop
- only deal 1 card each in flop
- only show one card and ?? for the other cards in show flow

