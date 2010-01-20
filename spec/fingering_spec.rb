require 'chords/fretboard'
require 'chords/fingering'

include Chords

describe Fingering do
  
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
  
end