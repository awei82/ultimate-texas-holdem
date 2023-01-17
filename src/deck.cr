require "./card"

class Deck

  getter cards : Array(Card)

  def initialize
    @cards = [] of Card
    ['S','H','D','C'].each do |suit|
      ['2','3','4','5','6','7','8','9','T','J','Q','K','A'].each do |rank|
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