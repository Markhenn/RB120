# Twenty One Game with OOP Implementation

class Participant
  # all that player and dealer have in common
end

class Player
  def initialize
    #name
    #cards
    #total value
  end

  def hit

  end

  def stay

  end

  def busted?

  end

  def return_total

  end
end

class Dealer
  def initialize
    #name
    #cards
    #total value
  end

  def hit

  end

  def stay

  end

  def busted?

  end

  def return_total

  end
end

class Deck
  SUITS = %w(Hearts Spades Diamonds Clubs)
  VALUES = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)

  def initialize
    @cards = Array.new
    reset
  end

  def shuffle
    cards.shuffle!
  end

  def deal_a_card
    cards.shift
  end

  def reset
    SUITS.each do |suit|
      VALUES.each do |value|
        cards << Card.new(suit, value)
      end
    end
  end

  private

  attr_reader :cards

end

class Card
  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  attr_reader :value, :suit

  private

  def to_s
    "#{@value} of #{@suit}"
  end
end

class TOGame
  def initialize
    @deck = Deck.new
    # player
    # dealer
  end

  def start
    display_welcome_message
    deal_cards
    show_initial_cards
    players_turn
    dealers_turn
    show_result
  end

  private

  attr_reader :deck

  def display_welcome_message
    puts 'Welcome to a game of Twenty One'
  end

  def deal_cards
    deck.shuffle
    # Set up players and deal each on two cards
    # Use deck.deal_a_card
  end

  def show_initial_cards
    puts 'the players cards are shown from the hand'
    puts 'one of the dealers cards is shown'
  end

  def players_turn
    puts 'the player hits and stays until happy'
    puts 'check if he busts'
  end

  def dealers_turn
    puts 'the dealer runs automatically until he reach 17+'
    puts 'check for bust'
  end

  def show_result
    puts 'the dealer wins'
    puts 'the player wins'
    puts 'it is a tie'
    puts 'both a bust'
  end
end

TOGame.new.start
