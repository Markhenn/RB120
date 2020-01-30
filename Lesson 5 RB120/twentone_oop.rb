# Twenty One Game with OOP Implementation

class Participant
  attr_reader :name, :cards

  def initialize
    @cards = []
    @name = set_name
  end

  def <<(card)
    cards << card
  end

  def busted?
    total_value > 21
  end

  def total_value
    value_of_cards = 0

    cards.each do |card|
      value_of_cards += card.points
    end

    value_of_cards += 10 if value_of_cards <= 10 && ace_in_hand?
    value_of_cards
  end

  private

  def ace_in_hand?
    cards.any? { |card| card.value == 'Ace' }
  end
end

class Player < Participant
  def hit

  end

  def stay?
    @stay
  end

  def stay
    @stay = true
  end

  private

  def set_name

    # TODO delete return
    return 'Mark'

    answer = nil
    loop do
      puts "Hey what is your name?"
      answer = gets.chomp.strip
      break unless answer.size < 2

      puts "Sorry that is too short, at least 2 letters please!"
      puts
    end

    answer
  end
end

class Dealer < Participant
  def stay?
    total_value >= 17
  end

  private

  def set_name
    self.class
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

  def points
    case value
    when 'Ace' then 1
    when /Jack|Queen|King/ then 10
    else value.to_i
    end
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
    @player = Player.new
    @dealer = Dealer.new
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

  attr_reader :deck, :player, :dealer

  def clear
    system 'clear'
  end

  def display_welcome_message
    puts 'Welcome to a game of Twenty One'
  end

  def deal_cards
    clear if player.cards.size > 2
    deck.shuffle
    player << deck.deal_a_card
    player << deck.deal_a_card
    dealer << deck.deal_a_card
    dealer << deck.deal_a_card
  end

  def show_initial_cards
    puts "Players Cards:"
    puts player.cards
    puts
    puts "Dealers Cards:"
    puts dealer.cards.first
    puts
  end

  def players_turn
    loop do

      answer = nil
      puts 'Do you want to hit or stay?'

      loop do
        puts 'Type h for hit and s for stay'
        answer = gets.chomp.downcase
        break if %w(h s hit stay).include? answer

        puts 'Invalid input!'
        puts
      end
      break if %(s stay).include? answer

      player << deck.deal_a_card
      break if player.busted?

      show_initial_cards
      puts player.total_value
    end
  end

  def dealers_turn
    loop do
      break if dealer.stay?
      dealer << deck.deal_a_card
    end
  end

  def show_result
    puts
    puts 'Player cards:'
    puts player.cards
    puts
    puts 'Dealer cards:'
    puts dealer.cards
    puts
    puts 'Player was busted' if player.busted?
    puts 'Dealer was busted' if dealer.busted?
    puts "The Player has #{player.total_value} points" unless player.busted?
    puts "The Dealer has #{dealer.total_value} points" unless dealer.busted?
  end
end

TOGame.new.start
