require 'rubygems'
require 'chords/fretboard'
require 'chords/fingering'

include Chords

describe Fingering do
  
  it "should behave correctly in array with uniq" do
    @fretboard = Fretboard.new([E.new, A.new, D.new], 12)
    f = Fingering.new(@fretboard, [3, nil, nil])
    f2 = Fingering.new(@fretboard, [3, nil, nil])
    [f, f2].uniq.should == [f]
  end
  
  describe "#expand" do
  
    it "should function with empty fingering" do
      @fretboard = Fretboard.new([E.new, A.new, D.new], 16)
      f = Fingering.new(@fretboard)
      fingerings = f.expand(E)
      fingerings.detect{|f| f == [0, nil, nil] }.should_not be_nil
      fingerings.detect{|f| f == [12, nil, nil] }.should_not be_nil
      fingerings.detect{|f| f == [nil, 7, nil] }.should_not be_nil
      fingerings.detect{|f| f == [nil, nil, 2] }.should_not be_nil
      fingerings.detect{|f| f == [nil, nil, 14] }.should_not be_nil
      fingerings.size.should == 5
    end
    
    it "should function with one existing position" do
      @fretboard = Fretboard.new([E.new, A.new, D.new], 16)
      f = Fingering.new(@fretboard, [3, nil, nil])
      fingerings = f.expand(D)
      fingerings.detect{|f| f == [3, 5, nil] }.should_not be_nil
      fingerings.detect{|f| f == [3, nil, 0] }.should_not be_nil
      # [3, nil, 12] exceeds max_fret_distance
    end
    
    it "should function with two existing positions" do
      @fretboard = Fretboard.new([E.new, A.new, D.new, G.new(1), B.new(1), E.new(2)], 16)
      f = Fingering.new(@fretboard, [3, 2, nil, nil, nil, nil])
      fingerings = f.expand(D)
      fingerings.detect{|f| f == [3, 2, 0, nil, nil, nil] }.should_not be_nil
      fingerings.detect{|f| f == [3, 2, nil, nil, 3, nil] }.should_not be_nil
      fingerings.size.should == 2
    end
    
  end
  
  describe "#add_duplicate" do
    it "should return [] if no unused strings" do
      fb = Fretboard.new([E.new, A.new, D.new], 12)
      f = Fingering.new(fb, [2, 0, 0])
      f.add_duplicate.should == []
    end
    
    it "should return variations (1)" do
      fb = Fretboard.new([E.new, A.new, D.new, G.new(1)], 12)
      f = Fingering.new(fb, [0, 11, 9, nil])
      duplicates = f.add_duplicate
      duplicates.should include([0,11,9,9])
      duplicates.size.should == 1
    end
    
    it "should return variations (2)" do
      fb = Fretboard.new([E.new, A.new, D.new, G.new(1)], 12)
      f = Fingering.new(fb, [0, 2, nil, nil])
      duplicates = f.add_duplicate
      duplicates.should include([0,2,2,nil])
      duplicates.should include([0,2,nil,4])
      duplicates.size.should == 2
    end
  end
  
  describe "#fid" do
    it "should return a proper string" do
      fingering = Fingering.new(Fretboard.standard, [0,2,2,1,0,0])
      fingering.fid.should == 'EADGBE022100'
    end
    it "should convert nil positions to x's" do
      fingering = Fingering.new(Fretboard.standard, [nil,0,2,2,2,0])
      fingering.fid.should == 'EADGBEx02220'
    end
  end
  
end