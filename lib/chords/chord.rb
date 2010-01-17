require 'chords/note'

module Chords
  
  class Chord
    attr_reader :base_note, :other_notes
    
    def initialize(base_note, *other_notes)
       @base_note, @other_notes = base_note, other_notes
    end
  end
  
  module ChordFactory
    extend self
    def new_major(base)
      Chord.new(base, base + 4, base + 7)
    end
    def new_minor(base)
      Chord.new(base, base + 3, base + 7)
    end
    def new_five(base)
      Chord.new(base, base + 7)
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