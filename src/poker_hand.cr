require "./card"

# 5 card poker hand
class PokerHand
  include Comparable(PokerHand)

  getter cards : Array(Card)
  getter ranking : String
  getter pair_value : UInt8
  getter second_pair_value : UInt8
  getter histogram : Hash(UInt8, UInt8)
  getter histogram_values : Array(UInt8)

  def initialize(@cards)
    raise "Hand must consist of 5 cards" unless @cards.size == 5

    @cards = @cards.sort.reverse

    @histogram = @cards.each_with_object(Hash(UInt8, UInt8).new(0)) {|c, h| h[c.rank_value] += 1}
    @histogram_values = @histogram.values

    @ranking = uninitialized String
    @pair_value = uninitialized UInt8
    @second_pair_value = uninitialized UInt8
    find_hand_ranking
  end

  def ranking_value
    HAND_RANKINGS[@ranking]
  end

  def ranking_pretty
    case @ranking
    when "Royal flush"
      "#{@ranking}! 💰💰💰"
    when "Straight flush", "Straight"
      if @cards.first.rank == 'A' && @cards[1].rank == '5'
        "#{@ranking}, A through 5"
      else
        "#{@ranking}, #{@cards.last.rank} through #{@cards.first.rank}"
      end
    when "Four of a kind", "Three of a kind"
      "#{@ranking}, #{Card.value_to_rank(pair_value)}'s"
    when "Full house"
      "#{@ranking}, #{Card.value_to_rank(pair_value)}'s over #{Card.value_to_rank(second_pair_value)}'s"
    when "Flush"
      "#{@ranking}, #{@cards.first.rank} high"
    when "Two pair"
      "#{@ranking}, #{Card.value_to_rank(pair_value)}'s and #{Card.value_to_rank(second_pair_value)}'s"
    when "Pair"
      "#{@ranking} of #{Card.value_to_rank(pair_value)}'s"
    when "High card"
      "#{@ranking}, #{@cards.first.rank}"
    end
  end

  def to_s(io : IO)
    io << "#{@cards.map(&.to_s).join("  , ")}\tranking: #{ranking_pretty}"
  end

  # used for tiebreaks for pairs + higher
  def non_paired_cards
    if [1,2,3,6,7].includes?(ranking_value)
      @cards.reject {|c| c.rank_value == @pair_value}.sort.reverse
    elsif [2,6].includes?(ranking_value)
      @cards.reject {|c| [@pair_value, @second_pair_value].includes?(c)}.sort.reverse
    else
      @cards
    end
  end

  def <=>(other)
    if ranking_value > other.ranking_value
      1
    elsif ranking_value < other.ranking_value
      -1
    else
      tiebreak(other)
    end
  end

  # tiebreak equal hand rankings
  private def tiebreak(other)
    # if pair, trip, or quads
    if [1, 3, 7].includes?(ranking_value)
      if @pair_value > other.pair_value
        1
      elsif @pair_value < other.pair_value
        -1
      else
        compare_kicker(other)
      end
    # if two pair
    elsif ranking_value == 2
      if @pair_value > other.pair_value
        1
      elsif @pair_value < other.pair_value
        -1
      else
        if @second_pair_value > other.second_pair_value
          1
        elsif @second_pair_value < other.second_pair_value
          -1
        else
          compare_kicker(other)
        end
      end
    # if full house
    elsif ranking_value == 6
      if @pair_value > other.pair_value
        1
      elsif @pair_value < other.pair_value
        -1
      else
        @second_pair_value <=> other.second_pair_value
      end
    else
      compare_kicker(other)
    end
  end

  # compare non-paired cards to see which has the highest kicker
  private def compare_kicker(other)
    non_paired_cards.map(&.rank_value) <=> other.non_paired_cards.map(&.rank_value)
  end

  
  # the `check_*` methods check if the hand matches the ranking, 
  # and sets the helper variables (@pair_value, @second_pair_value) as needed
  private def check_four_of_a_kind
    if histogram_values.includes?(4)
      @ranking = "Four of a kind"
      @pair_value = @histogram.key_for(4)
      true
    else
      false
    end
  end

  private def check_full_house
    if histogram_values.includes?(3) && histogram_values.includes?(2)
      @ranking = "Full house"
      @pair_value = @histogram.key_for(3)
      @second_pair_value = @histogram.key_for(2)
      true
    else
      false
    end
  end

  private def check_three_of_a_kind
    if histogram_values.includes?(3)
      @ranking = "Three of a kind"
      @pair_value = @histogram.key_for(3)
      true
    else
      false
    end
  end

  private def check_two_pair
    if histogram_values.sort == [1,2,2]
      @ranking = "Two pair"
      @second_pair_value, @pair_value = @histogram.select {|k,v| v == 2}.keys.sort
      true
    else
      false
    end
  end

  private def check_pair
    if histogram_values.includes?(2)
      @ranking = "Pair"
      @pair_value = @histogram.key_for(2)
    end
  end

  private def is_flush?
    suits = cards.map(&.suit)
    if suits[0] == suits[1] &&
      suits[0] == suits[2] &&
      suits[0] == suits[3] &&
      suits[0] == suits[4]
      true
    else
      false
    end
  end

  private def is_straight?
    return false if histogram_values != [1,1,1,1,1]
    (@cards.first.rank_value - @cards.last.rank_value == 4) || (@cards.first.rank_value == 12 && @cards[1] == 3)
  end

  # sets @ranking, @pair_value, and @second_pair_value
  # http://nsayer.blogspot.com/2007/07/algorithm-for-evaluating-poker-hands.html
  private def find_hand_ranking
    return if check_four_of_a_kind || check_full_house || check_three_of_a_kind || check_two_pair || check_pair
    
    @ranking = if is_flush? && is_straight?
      if cards.first.rank_value == 12
        "Royal flush"
      else
        "Straight flush"
      end
    elsif is_flush?
      "Flush"
    elsif is_straight?
      "Straight"
    else
      "High card"
    end
  end
end

HAND_RANKINGS = {
  "High card"=> 0_u8,
  "Pair"=> 1_u8,
  "Two pair" => 2_u8,
  "Three of a kind"=> 3_u8,
  "Straight"=> 4_u8,
  "Flush"=> 5_u8,
  "Full house"=> 6_u8,
  "Four of a kind"=> 7_u8,
  "Straight flush"=> 8_u8,
  "Royal flush"=> 9_u8,
}