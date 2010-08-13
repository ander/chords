require 'chords/fretboard'

include Chords

describe Fretboard do
  
  describe ".new_by_string" do
    it "should create right open notes" do
      fb = Fretboard.new_by_string('eadgbe', 12)
      fb.open_notes.should == Fretboard::TUNINGS[:standard]
    end
    
    it "should create right open notes (2)" do
      fb = Fretboard.new_by_string('eaeacse', 12)
      fb.open_notes.should == Fretboard::TUNINGS[:open_a]
    end
  end
  
  it "should parse positions right" do
    Fretboard.parse_positions('022100', 6).should == [0,2,2,1,0,0]
    Fretboard.parse_positions('0000010', 6).should == [0,0,0,0,0,10]
    Fretboard.parse_positions('01414130x', 6).should == [0,14,14,13,0,nil]
    Fretboard.parse_positions('357x0x', 6).should == [3,5,7,nil,0,nil]
    Fretboard.parse_positions('xxxxxx', 6).should == [nil]*6
  end
  
end