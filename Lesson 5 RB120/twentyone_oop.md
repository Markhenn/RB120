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

