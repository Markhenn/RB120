# Twenty One Game with OOP Implementation

module Clear
  def clear
    system 'clear'
  end
end

class Participant
  include Clear

  ACE_CORRECTION = 11
  TWENTY_ONE = 21

  attr_reader :name, :hand

  def initialize
    reset
    set_name
  end

  def busted?
    total_value > TWENTY_ONE
  end

  def hit_21?
    total_value == TWENTY_ONE
  end

  def total_value
    total_value = 0

    hand.each do |card|
      total_value += card.value
    end

    total_value += 10 if total_value <= 11 && ace_in_hand?
    total_value
  end

  def show_hand
    puts "----- #{name}'s Hand -----"
    hand.each do |card|
      puts "=> #{card}"
    end

    puts '=> ??' if hand.size == 1

    puts "Total value => #{total_value}"
    puts
  end

  def <<(card)
    hand << card
  end

  def >(opponent)
    total_value > opponent.total_value
  end

  def display_stays
    puts "#{name} stays!"
    puts
  end

  def display_hits
    puts "#{name} hits!"
    puts "and is dealt a #{hand.last}"
    puts
    show_hand
  end

  def display_busted
    puts "#{name} is busted!"
    puts
  end

  def display_hit_21
    puts "#{name} hits 21!"
    puts
  end

  def reset
    self.hand = Array.new
  end

  private

  attr_writer :name, :hand

  def ace_in_hand?
    hand.any?(&:ace?)
  end
end

class Player < Participant
  def stays?
    puts 'Do you want to hit or stay?'

    answer = nil
    loop do
      puts 'Type h for hit and s for stay'
      answer = gets.chomp.downcase
      break answer if %w(h s hit stay).include? answer

      puts 'Invalid input! Sorry!'
      puts
    end
    clear

    if %(s stay).include? answer
      true
    else
      false
    end
  end

  private

  def set_name
    answer = nil
    loop do
      puts "What is your name?"
      answer = gets.chomp.strip
      break unless answer.size < 2

      puts "Sorry that is too short, at least 2 letters please!"
      puts
    end
    clear

    self.name = answer
    puts "Welcome #{name}! Have fun playing Twenty One!"
    puts
  end
end

class Dealer < Participant
  DEALER_STAY = 17
  TABLES = {
    1 => { name: 'Alfred', min_bet: 1 },
    2 => { name: 'James', min_bet: 3 },
    3 => { name: 'Tony', min_bet: 5 }
  }

  attr_reader :min_bet

  def stays?
    total_value >= DEALER_STAY
  end

  private

  attr_writer :min_bet

  def set_name
    display_tables

    table = choose_table

    self.name = TABLES[table][:name]
    self.min_bet = TABLES[table][:min_bet]

    clear
    puts "You sit down at #{name}'s table"
    puts
  end

  def display_tables
    puts 'Choose one of the following dealer to play with:'
    TABLES.each do |idx, dealer|
      puts "Table #{idx} with dealer #{dealer[:name]} "\
        "and a minimum bet of #{dealer[:min_bet]}"
    end
    puts
  end

  def choose_table
    loop do
      puts 'Type the number of the table you want to play at'
      number = gets.chomp.to_i
      return number if TABLES.keys.include? number

      puts 'That is not the number of a table! Sorry!'
      puts
    end
  end
end

class Deck
  def initialize
    reset
  end

  def deal_a_card
    cards.shift
  end

  def reset
    self.cards = Array.new

    Card::SUITS.each do |suit|
      Card::FACES.each do |face|
        cards << Card.new(suit, face)
      end
    end
    shuffle
  end

  private

  attr_accessor :cards

  def shuffle
    cards.shuffle!
  end
end

class Card
  SUITS = %w(Hearts Spades Diamonds Clubs)
  FACES = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)

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

  attr_reader :suit, :face

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

class Funds
  include Clear

  FUNDS_MAX = 100
  FUNDS_MIN = 10

  def initialize
    set_funds
  end

  def set_funds
    funds = nil
    puts 'How much money would you like to bring to the table?'

    loop do
      puts "Please choose a whole number between #{FUNDS_MIN} and #{FUNDS_MAX}"
      funds = gets.chomp.to_i

      break if in_range?(funds)
      puts 'Invalid input for funds! Sorry!'
      puts
    end
    clear

    self.funds = funds.to_i
  end

  def to_s
    funds.to_s
  end

  def amount
    funds
  end

  def not_enough(bet)
    funds - bet < 0
  end

  def add(bet)
    self.funds = funds + bet
  end

  def deduct(bet)
    self.funds = funds - bet
  end

  def broke?(min_bet)
    funds < min_bet
  end

  private

  attr_accessor :funds

  def in_range?(funds)
    funds.to_i >= FUNDS_MIN && funds.to_i <= FUNDS_MAX
  end
end

class TOGame
  include Clear

  CONSOLE_WIDTH = 80
  INITIAL_FUNDS = 10

  def start
    display_welcome_message
    set_up_game
    loop do
      play_a_round
      wait_for_input
      break unless play_again?
      reset
      display_play_again_message
    end
    goodbye_message
  end

  private

  attr_accessor :deck, :player, :dealer, :current_p, :funds, :bet, :result

  # Start of the Game
  def display_welcome_message
    clear
    puts '----- Welcome to a game of Twenty One -----'
    puts
    puts 'You can decide how much money to bring to the table.'
    puts 'Each round you can win double or loose your whole bet.'
    puts 'When you have less money left than the min bet left the game ends.'
    puts 'Of course you can decide to leave after every round.'
    puts
    puts "Let's get started with setting up the game!"
    puts
  end

  def set_up_game
    self.deck = Deck.new
    self.player = Player.new
    self.dealer = Dealer.new
    self.current_p = player
    self.funds = Funds.new
  end

  # Play a round methods
  def play_a_round
    deal_cards
    show_flop
    deal_cards
    make_a_bet
    wait_for_input

    current_participants_turn
    wait_for_input

    unless player.busted?
      change_participant
      current_participants_turn
      wait_for_input

      change_participant
    end
    end_of_round
  end

  def end_of_round
    determine_winner
    show_result
    update_funds
    show_funds
  end

  def change_participant
    self.current_p = if player?
                       dealer
                     else
                       player
                     end
  end

  def player?
    current_p == player
  end

  def deal_cards
    player << deck.deal_a_card
    dealer << deck.deal_a_card
  end

  def show_flop
    puts 'Here is the flop'
    player.show_hand
    dealer.show_hand
  end

  def make_a_bet
    show_funds
    puts 'How much money would like to bet on the flop?'
    puts "The minimum bet is $#{dealer.min_bet}"
    puts 'Only whole numbers allowed!'

    number = nil

    loop do
      number = gets.chomp
      break if valid?(number)
      puts
    end
    puts
    puts "#{player.name} bets $#{number} on the flop"
    puts

    self.bet = number.to_i
  end

  def valid?(bet)
    puts
    if !integer?(bet)
      puts 'Please use only whole numbers for the bet'
    elsif bet.to_i < dealer.min_bet
      puts "The amount must be bigger than the min bet of #{dealer.min_bet}!"
    elsif funds.not_enough(bet.to_i)
      puts "The bet can't be higher than your available funds "\
        "of ($#{funds.amount})."
    else
      true
    end
  end

  def integer?(number)
    number.to_i.to_s == number
  end

  def current_participants_turn
    display_turn_start

    loop do
      break if current_p.busted? || current_p.hit_21? || current_p.stays?
      clear if player?
      current_p << deck.deal_a_card
      current_p.display_hits
    end

    display_turn_end
  end

  def display_turn_end
    if current_p.busted?
      current_p.display_busted
    elsif current_p.hit_21?
      current_p.display_hit_21
    else
      current_p.display_stays
    end
  end

  def display_turn_start
    puts "#{current_p.name}'s Turn"
    puts
    current_p.show_hand
  end

  def determine_winner
    self.result = if dealer.busted? || (player > dealer && !player.busted?)
                    :player_won
                  elsif player.busted? || dealer > player
                    :dealer_won
                  end
  end

  def show_result
    puts '*' * CONSOLE_WIDTH
    puts "*#{' ' * (CONSOLE_WIDTH - 2)}*"
    puts "*#{display_round_result.center(CONSOLE_WIDTH - 2)}*"
    puts "*#{' ' * (CONSOLE_WIDTH - 2)}*"
    puts '*' * CONSOLE_WIDTH

    player.show_hand
    dealer.show_hand
  end

  def update_funds
    if player_won?
      puts "#{player.name} wins $#{bet}"
      funds.add(bet)
    elsif dealer_won?
      puts "#{player.name} looses $#{bet}"
      funds.deduct(bet)
    end
    puts
  end

  def player_won?
    result == :player_won
  end

  def dealer_won?
    result == :dealer_won
  end

  def display_round_result
    if result == :player_won
      display_player_won
    elsif result == :dealer_won
      display_dealer_won
    else
      "It is a tie with #{player.total_value} points each"
    end
  end

  def display_player_won
    if dealer.busted?
      "The #{dealer.name} busted and #{player.name} wins the round"
    else
      "#{player.name} wins with #{player.total_value} "\
        "points to #{dealer.total_value} points"
    end
  end

  def display_dealer_won
    if player.busted?
      "#{player.name} busted and lost"
    else
      "#{dealer.name} wins with #{dealer.total_value} "\
        "points to #{player.total_value} points"
    end
  end

  # Helper methods
  def show_funds
    puts "------ #{player.name}'s funds ----"
    puts "=> $#{funds}"
    puts
  end

  def wait_for_input
    puts 'Type any key to continue...'
    gets
    clear
  end

  def reset
    deck.reset
    player.reset
    dealer.reset
  end

  # End of Game methods
  def play_again?
    return if funds.broke?(dealer.min_bet)

    display_play_again
    answer = gets.chomp.downcase
    clear

    answer.start_with? 'y'
  end

  def display_play_again
    puts '----- Want to play again? -----'
    puts "You have $#{funds} left to play"
    puts "The minimum bet at #{dealer.name}'s table is $#{dealer.min_bet}"
    puts
    puts "Type y if you want to play #{dealer.name} again, "\
      "anything else to end the game"
  end

  def display_play_again_message
    puts "Let's play again!"
    puts
  end

  def goodbye_message
    puts '----- The game is over -----'
    if funds.broke?(dealer.min_bet)
      puts "The game ended because you had only $#{funds} left! This is less "\
        "than the min bet of $#{dealer.min_bet} at #{dealer.name}'s table"
    else
      puts "You leave #{dealer.name}'s table and cash in $#{funds}"
    end
    puts
    puts 'Thank you for playing Twenty One!'
  end
end

TOGame.new.start
