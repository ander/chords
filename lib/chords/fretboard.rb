require 'chords/chord'
require 'chords/text_formatter'

module Chords
  
  class Fretboard
    
    def initialize(base_notes, frets)
      @base_notes, @frets = base_notes, frets
      @max_fret_distance = 3
      @formatter = TextFormatter.new
    end
    
    # Guitar in standard tuning
    def self.standard
      Fretboard.new([E.new, A.new, D.new, G.new(1), B.new(1), E.new(1)], 16)
    end
    
    # DADGAD tuning
    def self.dadgad
      Fretboard.new([D.new(-1), A.new, D.new, G.new(1), A.new(1), D.new(1)], 16)
    end
    
    def find(chord)
      fingerings = find_fingerings(chord)
      @formatter.output(fingerings)
    end
    
    private
    
    def find_fingerings(chord)
      return [[0, 2, 2, 1, 0, 0]]
    end
    
  end

end