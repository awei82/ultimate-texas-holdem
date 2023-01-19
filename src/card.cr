struct Card
  RANKS = ['2','3','4','5','6','7','8','9','T','J','Q','K','A']
  SUITS = {'S'=>"\033[92m ♠️\033[00m", 'H'=>"\033[91m ♥️\033[00m",'C'=> "\033[92m ♣️\033[00m", 'D'=>"\033[91m ♦️\033[00m"}
  
  def self.value_to_rank(v)
    case v
    when 12
      'A'
    when 11
      'K'
    when 10
      'Q'
    when 9
      'J'
    when 8
      'T'
    else
      (v+2).to_s[0]
    end
  end

  include Comparable(Card)

  property rank       : Char
  property suit       : Char
  property rank_value : UInt8

  def initialize(card_string : String)
    raise "Incorrect card_string format" if card_string.size != 2

    @rank = card_string[0]
    raise "Incorrect rank character" unless RANKS.includes?(@rank)

    @suit = card_string[1]
    raise "Incorrect suit character" unless SUITS.keys.includes?(@suit)

    @rank_value = case @rank
                  when 'A'
                    12_u8
                  when 'K'
                    11_u8
                  when 'Q'
                    10_u8
                  when 'J'
                    9_u8
                  when 'T'
                    8_u8
                  else
                    @rank.to_u8 - 2
                  end
  end

  def to_s(io : IO)
    io << "#{@rank}#{SUITS[@suit]}"
  end

  def <=>(other)
    if @rank_value > other.rank_value
      1
    elsif @rank_value < other.rank_value
      -1
    else
      0
    end
  end
end

