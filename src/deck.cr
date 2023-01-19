require "./card"

class Deck

  getter cards : Array(Card)

  def initialize
    @cards = [] of Card
    Card::SUITS.keys.each do |suit|
      Card::RANKS.each do |rank|
        @cards << Card.new("#{rank}#{suit}")
      end
    end

    @cards.shuffle!
  end

  def size
    @cards.size
  end

  def draw
    @cards.pop
  end
end