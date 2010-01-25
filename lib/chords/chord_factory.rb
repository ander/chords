require 'chords/chord'

module Chords
  module ChordFactory
    extend self
    CHORDS = {:major  => [4,7],
              :minor  => [3,7],
              :five   => [7],
              :sus2   => [2, 7],
              :sus4   => [5, 7],
              :aug    => [4, 8],
              :dim    => [3, 6],
              :minus5 => [4, 6]}
    
    def new_chord(root, key)
      raise "No chord with key #{key}" unless CHORDS.has_key?(key)
      notes = [root]
      notes += CHORDS[key].map{|interval| root + interval}
      Chord.new(notes)
    end
  end
  
  # Extensions to Note so we can say for example 'E.major' to create a chord
  module NoteExt
    ChordFactory::CHORDS.keys.each do |key|
      define_method key do
        ChordFactory.new_chord(self, key)
      end
    end
  end
  
  NOTES.flatten.each{|note_name| Chords.const_get(note_name).extend NoteExt}
end