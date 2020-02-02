# Twenty One Game with OOP Implementation

module Hand
  ACE_CORRECTION = 11
  BUSTED_VALUE = 21

  def busted?
    total_value > BUSTED_VALUE
  end

  def total_value
    total_value = 0

    cards.each do |card|
      total_value += card.value
    end

    total_value += 10 if total_value <= 11 && ace_in_hand?
    total_value
  end

  def show_hand
    puts "----- #{name}'s Hand -----"
    cards.each do |card|
      puts "=> #{card}"
    end

    puts "Total value => #{total_value}"
    puts
  end

  def <<(card)
    cards << card
  end

  def >(opponent)
    total_value > opponent.total_value
  end

  private

  def ace_in_hand?
    cards.any?(&:ace?)
  end
end

class Participant
  attr_reader :name, :cards

  def initialize
    @cards = []
    set_name
  end

  def display_stays
    puts "#{name} stays!"
    puts
  end

  def display_hits
    puts "#{name} hits!"
    puts "and is dealt a #{cards.last}"
    puts
    show_hand
  end

  def display_busted
    puts "#{name} is busted!"
    puts
  end

  def reset
    @cards = []
  end

  private

  attr_writer :name
end

class Player < Participant
  include Hand

  def stays?
    puts 'Do you want to hit or stay?'

    answer = nil
    loop do
      puts 'Type h for hit and s for stay'
      answer = gets.chomp.downcase
      break answer if %w(h s hit stay).include? answer

      puts 'Invalid input!'
      puts
    end
    puts

    if %(s stay).include? answer
      true
    else
      false
    end
  end

  private

  def set_name
    # TODO delete return
    # return self.name = 'Mark'

    answer = nil
    loop do
      puts "Hey what is your name?"
      answer = gets.chomp.strip
      break unless answer.size < 2

      puts "Sorry that is too short, at least 2 letters please!"
      puts
    end

    self.name = answer
  end
end

class Dealer < Participant
  DEALER = %w(James Tony Alfred)

  include Hand

  def stays?
    total_value >= 17
  end

  private

  def set_name
    self.name = DEALER.sample
  end
end

class Deck
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
    Card::SUITS.each do |suit|
      Card::FACES.each do |face|
        cards << Card.new(suit, face)
      end
    end
  end

  private

  attr_reader :cards
end

class Card
  SUITS = %w(Hearts Spades Diamonds Clubs)
  FACES = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)

  attr_reader :face

  def initialize(suit, face)
    @suit = suit
    @face = face
  end

  def value
    return 1 if ace?
    return 10 if jack? || queen? || king?
    face.to_i
  end

  def ace?
    face == 'Ace'
  end

  private

  attr_reader :suit

  def king?
    face == 'King'
  end

  def queen?
    face == 'Queen'
  end

  def jack?
    face == 'Jack'
  end

  def to_s
    "#{face} of #{suit}"
  end
end

class TOGame
  CONSOLE_WIDTH = 80

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
    @current_participant = player
  end

  def start
    display_welcome_message
    loop do
      play_a_round
      break unless play_again?
      reset
      display_play_again_message
    end
    goodbye_message
  end

  private

  attr_reader :deck, :player, :dealer
  attr_accessor :current_participant

  def clear
    system 'clear'
  end

  def display_welcome_message
    clear
    puts 'Welcome to a game of Twenty One'
    puts
  end

  def play_a_round
    deal_cards
    show_flop

    current_participants_turn
    wait_for_input

    unless player.busted?
      change_participant
      current_participants_turn
      wait_for_input

      change_participant
    end

    show_result
  end

  def change_participant
    self.current_participant = if player?
                                 dealer
                               else
                                 player
                               end
  end

  def player?
    current_participant == player
  end

  def play_again?
    puts
    puts "Type y if you want to play #{dealer.name} again"
    answer = gets.chomp.downcase
    clear

    answer.start_with? 'y'
  end

  def display_play_again_message
    puts "Let's play again!"
    puts
  end

  def reset
    deck.reset
    player.reset
    dealer.reset
  end

  def deal_cards
    deck.shuffle
    player << deck.deal_a_card
    player << deck.deal_a_card
    dealer << deck.deal_a_card
  end

  def show_flop
    puts 'Here is the flop'
    player.show_hand
    dealer.show_hand

    # Little trick to avoid showing both dealer cards
    dealer << deck.deal_a_card
  end

  def current_participants_turn
    display_turn_start

    loop do
      break if current_participant.busted? || current_participant.stays?
      clear if player?
      current_participant << deck.deal_a_card
      current_participant.display_hits
    end

    display_turn_end
  end

  def display_turn_end
    if current_participant.busted?
      current_participant.display_busted
    else
      current_participant.display_stays
    end
  end

  def display_turn_start
    puts "#{current_participant.name}'s Turn"
    puts
    current_participant.show_hand unless player?
  end

  def show_result
    puts '*' * CONSOLE_WIDTH
    puts "*#{' ' * CONSOLE_WIDTH}*"
    puts "*#{round_result.center(CONSOLE_WIDTH - 2)}*"
    puts "*#{' ' * CONSOLE_WIDTH}*"
    puts '*' * CONSOLE_WIDTH

    player.show_hand
    dealer.show_hand
  end

  def wait_for_input
    puts 'Type any key to continue...'
    gets
    clear
  end

  # rubocop:disable Metrics/AbcSize
  def round_result
    if player.busted?
      "#{player.name} busted and lost"
    elsif dealer.busted?
      "The #{dealer.name} busted and #{player.name} wins the round"
    elsif player > dealer
      "#{player.name} wins with #{player.total_value} "\
        "points to #{dealer.total_value} points"
    elsif dealer > player
      "#{dealer.name} wins with #{dealer.total_value} "\
        "points to #{player.total_value} points"
    else
      "It is a tie with #{player.total_value} points each"
    end
  end
  # rubocop:enable Metrics/AbcSize

  def goodbye_message
    clear
    puts 'Thank you for playing twentyone!'
  end
end

TOGame.new.start
