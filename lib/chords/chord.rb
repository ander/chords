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
    
    def add9
      Chord.new(@notes + [@root + 14])
    end
    
    def add11
      Chord.new(@notes + [@root + 17])
    end
  end
  
  module ChordFactory
    extend self
    @@chords = {}
    
    def new_major(root)
      Chord.new(root, root + 4, root + 7)
    end
    def new_minor(root)
      Chord.new(root, root + 3, root + 7)
    end
    def new_five(root)
      Chord.new(root, root + 7)
    end
  end
  
  # Extensions to Note so we can say for example 'E.major' to create a chord
  module NoteExt
    def major; ChordFactory.new_major(self) end
    def minor; ChordFactory.new_minor(self) end
    def five;  ChordFactory.new_five(self)  end
  end
  
  NOTES.flatten.each{|note_name| Chords.const_get(note_name).extend NoteExt}
  
end