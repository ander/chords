require 'chords/note'

module Chords
  
  class Chord
    attr_reader :notes
    attr_accessor :root
    
    def initialize(title_parts, *notes)
      @title_parts = title_parts
      @notes = notes.flatten
      @root = @notes.first
    end
    
    def first_inversion
      raise "Not enough notes for inversion" if notes.size < 3
      inversion = Chord.new(@title_parts.dup + ['1st inv.'],
                            @notes[1], @notes[2], @root, *@notes[3..-1])
      inversion.root = @root
      inversion
    end
    
    def second_inversion
      raise "Not enough notes for inversion" if notes.size < 3
      inversion = Chord.new(@title_parts.dup + ['2nd inv.'],
                            @notes[2], @root, @notes[1], *@notes[3..-1])
      inversion.root = @root
      inversion
    end
    
    def sixth
      chord = Chord.new(@title_parts.dup + ['6th'], @notes + [@root + 9])
      chord.root = @root
      chord
    end
    
    def seventh
      chord = Chord.new(@title_parts.dup + ['7th'], @notes + [@root + 10])
      chord.root = @root
      chord
    end
    
    def add9
      chord = Chord.new(@title_parts.dup + ['add9'], @notes + [@root + 14])
      chord.root = @root
      chord
    end
    
    def add11
      chord = Chord.new(@title_parts.dup + ['add11'], @notes + [@root + 17])
      chord.root = @root
      chord
    end
    
    def bass(note)
      chord = Chord.new(@title_parts.dup + ["(bass #{note.title})"], [note] + @notes)
      chord.root = @root
      chord
    end
    
    def title
      ret = @root.title
      ret += " #{@title_parts.join(' ')}" unless @title_parts.empty?
      ret
    end
    
  end
  
end