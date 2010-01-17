require 'chords/chord'

module Chords
  
  class Fretboard
    def initialize(base_notes, frets)
      @base_notes, @frets = base_notes, frets
    end
    
    # Guitar in standard tuning
    def self.standard
      Fretboard.new([E.new, A.new, D.new, G.new(1), B.new(1), E.new(1)], 16)
    end
    
    # DADGAD tuning
    def self.dadgad
      Fretboard.new([D.new(-1), A.new, D.new, G.new(1), A.new(1), D.new(1)], 16)
    end
    
  end

end