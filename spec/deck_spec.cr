require "./spec_helper"

describe Deck do
  it "creates a 52-card deck" do
    deck = Deck.new
    deck.size.should eq 52
  end

  it "draws a card" do
    deck = Deck.new
    card = deck.draw
    card.class.should eq Card
    deck.size.should eq 51
  end
end
