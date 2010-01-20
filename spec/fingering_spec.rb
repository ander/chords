require 'chords/fretboard'
require 'chords/fingering'

include Chords

describe Fingering do
  
  describe "#expand" do
    
    before(:each) do
      @fretboard = Fretboard.new([E.new, A.new, D.new], 16)
    end
    
    it "should function with empty fingering" do
      f = Fingering.new(@fretboard)
      fingerings = f.expand(E)
      fingerings.detect{|f| f == [0, nil, nil] }.should_not be_nil
      fingerings.detect{|f| f == [12, nil, nil] }.should_not be_nil
      fingerings.detect{|f| f == [nil, 7, nil] }.should_not be_nil
      fingerings.detect{|f| f == [nil, nil, 2] }.should_not be_nil
      fingerings.detect{|f| f == [nil, nil, 14] }.should_not be_nil
      fingerings.size.should == 5
    end
    
  end
  
end