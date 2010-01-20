require 'chords/note'

module Chords
  
  class Chord
    attr_reader :notes
    attr_accessor :root
    
    def initialize(*notes)
      @notes = notes.flatten
      @root = @notes.first
    end
    
    def first_inversion
      raise "Not enough notes for inversion" if notes.size < 3
      inversion = Chord.new(@notes[1], @notes[2], @root, *@notes[3..-1])
      inversion.root = @root
      inversion
    end
    
    def second_inversion
      raise "Not enough notes for inversion" if notes.size < 3
      inversion = Chord.new(@notes[2], @root, @notes[1], *@notes[3..-1])
      inversion.root = @root
      inversion
    end
    
    def sixth
      Chord.new(@notes + [@root + 9])
    end
    
    def seventh
      Chord.new(@notes + [@root + 10])
    end
    
    def add9
      Chord.new(@notes + [@root + 14])
    end
    
    def add11
      Chord.new(@notes + [@root + 17])
    end
    
    def bass(note)
      chord = Chord.new([note] + @notes)
      chord.root = self.root
      chord
    end
    
  end
  
end