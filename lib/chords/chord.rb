require 'chords/note'

module Chords
  
  class Chord
    attr_reader :root, :notes
    
    def initialize(root, *notes)
       @root, @notes = root, notes
    end
    
    def first_inversion
      raise "Not enough notes for inversion" if notes.size < 2
      Chord.new(@notes[0], @notes[1], @root)
    end
    
    def second_inversion
      raise "Not enough notes for inversion" if notes.size < 2
      Chord.new(@notes[1], @root, @notes[0])
    end
    
  end
  
  module ChordFactory
    extend self
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