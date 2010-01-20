require 'chords/chord_factory'
require 'chords/fingering'
require 'chords/text_formatter'

module Chords
  
  class Fretboard
    attr_reader :frets, :open_notes
    
    def initialize(open_notes, frets)
      @open_notes, @frets = open_notes, frets
      @formatter = TextFormatter.new(self)
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
      fingerings = Fingering.find_variations(self, chord)
      @formatter.output(fingerings)
    end
    
  end
end