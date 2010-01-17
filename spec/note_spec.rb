require 'chords/note'

include Chords

describe Note do
  
  it "should allow adding interval to Note class" do
    (A + 5).should == D
    (Ds + 3).should == Fs
  end
  
  describe ".create_by_value" do
    it "should work with value < 12" do
      n = Note.create_by_value(10)
      n.should be_a D
      n.octave.should == 0
      n.interval.should == 10
    end
    
    it "should work with value > 12" do
      n = Note.create_by_value(27)
      n.should be_a G
      n.octave.should == 2
      n.interval.should == 3
    end
    
    it "should work with value < 0" do
      n = Note.create_by_value(-23)
      n.should be_a F
      n.octave.should == -2
      n.interval.should == 1
    end  
  end
  
  it "should allow comparing with other notes" do
    (A.new > Gs.new).should be_true
  end

  it "should allow comparing with values" do
    (C.new == 8).should be_true
    (E.new < 5).should be_true
    (D.new > 7).should be_true
    E.new(1).should == 12
    (G.new + G.new).should == 6 # a bit senseless
  end
  
end
