require "./spec_helper"

describe PokerHand do
  it "only accepts 5-card hands" do
    cards = ["2H","3H","4H","5H","6H"].map {|s| Card.new(s)}
    PokerHand.new(cards)

    cards << Card.new("7H")
    expect_raises(Exception) { PokerHand.new(cards)}

    cards.pop(2)
    expect_raises(Exception) { PokerHand.new(cards)}
  end

  it "correctly generates the histogram" do
    cards = ["2H","3H","4H","5H","2S"].map {|s| Card.new(s)}
    hand = PokerHand.new(cards)

    hand.histogram.should eq({0 => 2, 1 => 1, 2 => 1, 3 => 1})
    hand.histogram_values.should eq [1,1,1,2]
  end

  it "correctly ranks a Royal flush" do
    cards = ["TH","JH","QH","KH","AH"].map {|s| Card.new(s)}
    hand = PokerHand.new(cards)

    hand.ranking.should eq "Royal flush"
  end

  it "correctly ranks a Straight flush" do
    cards = ["9H","TH","JH","QH","KH"].map {|s| Card.new(s)}
    hand = PokerHand.new(cards)

    hand.ranking.should eq "Straight flush"
  end

  it "correctly ranks a Four of a kind" do
    cards = ["2H","2S","2C","2D","3S"].map {|s| Card.new(s)}
    hand = PokerHand.new(cards)

    hand.ranking.should eq "Four of a kind"
    hand.pair_value.should eq 0
  end

  it "correctly ranks a Full house" do
    cards = ["2H","2S","3C","3D","3S"].map {|s| Card.new(s)}
    hand = PokerHand.new(cards)

    hand.ranking.should eq "Full house"
    hand.pair_value.should eq 1
    hand.second_pair_value.should eq 0
  end

  it "correctly ranks a Flush" do
    cards = ["2S","4S","6S","7S","9S"].map {|s| Card.new(s)}
    hand = PokerHand.new(cards)

    hand.ranking.should eq "Flush"
  end

  it "correctly ranks a Straight" do
    cards = ["2H","3S","4C","5D","6S"].map {|s| Card.new(s)}
    hand = PokerHand.new(cards)

    hand.ranking.should eq "Straight"
  end

  it "correctly ranks a Three of a kind" do
    cards = ["2H","2S","2C","3D","4S"].map {|s| Card.new(s)}
    hand = PokerHand.new(cards)

    hand.ranking.should eq "Three of a kind"
    hand.pair_value.should eq 0
  end

  it "correctly ranks a Two pair" do
    cards = ["2H","2S","3C","3D","4S"].map {|s| Card.new(s)}
    hand = PokerHand.new(cards)

    hand.ranking.should eq "Two pair"
    hand.pair_value.should eq 1
    hand.second_pair_value.should eq 0
  end

  it "correctly ranks a Pair" do
    cards = ["2H","2S","3C","4D","5S"].map {|s| Card.new(s)}
    hand = PokerHand.new(cards)

    hand.ranking.should eq "Pair"
    hand.pair_value.should eq 0
  end

  it "correctly ranks a High card" do
    cards = ["2H","3S","4C","5D","7S"].map {|s| Card.new(s)}
    hand = PokerHand.new(cards)

    hand.ranking.should eq "High card"
  end

  it "correctly compares two hands" do
    hand1 = PokerHand.new(["9H","9S","3C","3D","3S"].map {|s| Card.new(s)})
    hand2 = PokerHand.new(["2H","2S","2C","3S","4S"].map {|s| Card.new(s)})

    (hand1 > hand2).should be_true

    hand1 = PokerHand.new(["2S","4S","6S","7S","9S"].map {|s| Card.new(s)})
    hand2 = PokerHand.new(["2H","4H","6H","7H","9H"].map {|s| Card.new(s)})
    (hand1 == hand2).should be_true
  end

  it "correctly compares pair values" do
    hand1 = PokerHand.new(["3H","3S","5C","5D","4S"].map {|s| Card.new(s)})
    hand2 = PokerHand.new(["2H","2S","5C","5D","4S"].map {|s| Card.new(s)})

    (hand1 > hand2).should be_true

    hand1 = PokerHand.new(["3H","3S","5C","5D","4S"].map {|s| Card.new(s)})
    hand2 = PokerHand.new(["3H","3S","5C","5D","4H"].map {|s| Card.new(s)})

    (hand1 == hand2).should be_true
  end

  it "correctly compares kicker cards" do
    hand1 = PokerHand.new(["9H","9S","AC","5D","4S"].map {|s| Card.new(s)})
    hand2 = PokerHand.new(["9D","9C","8C","5D","4S"].map {|s| Card.new(s)})

    (hand1 > hand2).should be_true

    hand1 = PokerHand.new(["AH","JS","TC","9D","8S"].map {|s| Card.new(s)})
    hand2 = PokerHand.new(["AD","JC","TD","9S","7S"].map {|s| Card.new(s)})

    (hand1 > hand2).should be_true
  end
end
