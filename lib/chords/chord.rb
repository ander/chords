require 'chords/note'
require 'singleton'

module Chords
  
  class Chord
    def initialize(base, other_notes)
       
    end
  end
  
  class ChordGenerator
    include Singleton
    
    def create_major(base)
    end
    def create_minor(base)
    end
    def create_five(base)
    end
  end
  
  # Extensions to Note so we can say for example 'E.major' to create a chord
  module ChordExt
    def major
      ChordGenerator.instance.create_major(self)
    end
    
    def minor
      ChordGenerator.instance.create_minor(self)
    end
    
    def five
      ChordGenerator.instance.create_five(self)
    end
  end
  
  NOTES.flatten.each{|note_name| Chords.const_get(note_name).extend ChordExt}
  
end