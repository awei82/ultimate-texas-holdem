require "./spec_helper"

describe Card do
  it "creates a Card" do
    Card.new("AS")
  end

  it "compares Cards by rank_value" do
    a = Card.new("AS")
    b = Card.new("AH")
    c = Card.new("TS")

    (a == b).should be_true
    (a > c).should be_true
  end

  it "to_s print the card string" do
    a = Card.new("AS")
    a.to_s.should eq "A♠️"
  end
end
