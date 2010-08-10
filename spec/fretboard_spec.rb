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
  
  describe ".print_fingering_by_fid" do
    
  end
  
end