require 'chords/chord'

include Chords

describe Chord do
  
  it "should create first inversion" do
    emaj = E.major.first_inversion
    emaj.root.should == Gs
    emaj.notes.should == [B, E]
  end
  
  it "should create second inversion" do
    fm = F.minor.second_inversion
    fm.root.should == C
    fm.notes.should == [F, Gs]
  end
  
end