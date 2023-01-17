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

  deck = Deck.new

  your_cards = (1..2).map { deck.draw }
  puts "Your cards:         #{pretty_string(your_cards)}"

  dealer_cards = (1..2).map { deck.draw }
  puts "Dealer's cards:     #{pretty_string(dealer_cards)}"

  puts "\n"
  community_cards = (1..5).map { deck.draw }
  puts "Community cards:    #{pretty_string(community_cards)}"
  puts "\n"

  your_best_hand = find_best_hand(your_cards + community_cards)
  puts "Your best hand:     #{your_best_hand}"

  dealer_best_hand = find_best_hand(dealer_cards + community_cards)
  puts "Dealer's best hand: #{dealer_best_hand}"

  puts "\n"
  case your_best_hand <=> dealer_best_hand
  when 1
    puts "You win!"
  when -1
    puts "You lose."
  else
    puts "It's a tie!"
  end
end
