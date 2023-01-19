require "./card"
require "./deck"
require "./poker_hand"

module UltimateTexasHoldem
  VERSION = "0.1.0"

  def self.pretty_string(cards : Array(Card))
    cards.map(&.to_s).join("  , ")
  end

  # return the best 5-card hand the given 5 or more cards
  def self.find_best_hand(cards : Array(Card))
    if cards.size == 5
      PokerHand.new(cards)
    else
      count = cards.size
      (1..count).map {|n| find_best_hand(cards.rotate(n).first(count-1)).as(PokerHand) }.sort.last
    end
  end

  # compares the first char of the user input to the list of options,
  # and returns the one it matches with. Returns default if no matches.
  def self.get_char_response(options : Array(Char), default : Char)
    response = gets

    if response.nil? || response.blank?
      return default
    end

    response = response.downcase[0]

    options.each do |o|
      return o if response == o
    end

    return default
  end

  def self.player_bet
    print "\n(B)et or (C)heck? (C): "
    
    if get_char_response(['b','c'], 'c') == 'c'
      puts "You checked."
      :check
    else
      puts "You bet."
      :bet
    end
  end

  def self.final_bet
    print "\n(B)et or (F)old? (B):"
    
    if get_char_response(['b','f'], 'b') == 'b'
      puts "You bet."
      :bet
    else
      puts "You folded."
      :fold
    end
  end

  def self.play_round
    deck = Deck.new

    your_cards = (1..2).map { deck.draw }
    puts "Your cards:         #{pretty_string(your_cards)}"

    action = player_bet()

    puts "\n"
    community_cards = (1..3).map { deck.draw }
    puts "Flop cards:         #{pretty_string(community_cards)}"

    action = player_bet() if action == :check

    puts "\n"
    community_cards << deck.draw
    community_cards << deck.draw
    puts "Community cards:    #{pretty_string(community_cards)}"

    action = final_bet() if action == :check
    return if action == :fold

    puts "\n"
    dealer_cards = (1..2).map { deck.draw }
    dealer_best_hand = find_best_hand(dealer_cards + community_cards)

    if dealer_best_hand.ranking == "High card"
      puts "Dealer folds. You win! 🎉"
    else
      puts "Dealer's cards:     #{pretty_string(dealer_cards)}"
      puts "Dealer's best hand: #{dealer_best_hand}"

      your_best_hand = find_best_hand(your_cards + community_cards)
      puts "\n"
      puts "Your best hand:     #{your_best_hand}"

      puts "\n"
      case your_best_hand <=> dealer_best_hand
      when 1
        puts "You win! 🎉"
      when -1
        puts "You lose. 🙁"
      else
        puts "It's a tie!"
      end
    end
  end

  def self.run
    puts "Welcome to Ultimate Texas Hold'em!\n"

    response = "Y"
    while true
      puts "\n"
      play_round()

      print "\n\nPlay again? (Y)es/(N)o (Y): "
      response = get_char_response(['y','n'], 'n')
      break if response == 'n'
    end
  end
end


UltimateTexasHoldem.run