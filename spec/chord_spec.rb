require 'chords/chord'

include Chords

describe Chord do
  
  it "should create first inversion" do
    emaj = E.major.first_inversion
    emaj.root.should == E
    emaj.notes.should == [Gs, B, E]
  end
  
  it "should create second inversion" do
    fm = F.minor.second_inversion
    fm.root.should == F
    fm.notes.should == [C, F, Gs]
  end
  
end