require 'forwardable'

module Chords
  
  class Fingering
    extend Forwardable
    
    def_delegators :@positions, :[], :==, :inspect, :each, :each_with_index
    
    def initialize(fretboard, positions=nil)
      @fretboard = fretboard
      @positions = positions || ([nil] * @fretboard.open_notes.size)
      @max_fret_distance = 4
    end
    
    # Returns all fingering variations of this fingering
    # expanded with note.
    # Expanded note wil be on a higher string than existing notes.
    # It will also be the highest note.
    def expand(note)
      fingerings = []
      
      ((highest_used_string+1)..(@positions.size-1)).each do |str_i|
        open_note = @fretboard.open_notes[str_i]
        pos = note.new(open_note.octave).value - open_note.value
        pos += 12 if pos < 0
        
        while pos <= @fretboard.frets
          pos_arr = (@positions + [pos]).select{|p| !p.nil? && p > 0}
          distance = (pos_arr.max || 0) - (pos_arr.min || 0)
          
          if distance <= @max_fret_distance and (open_note + pos) > highest_note
            new_positions = @positions.dup
            new_positions[str_i] = pos
            fingerings << Fingering.new(@fretboard, new_positions)
          end
          
          pos += 12
        end
      end
      
      fingerings
    end
    
    def self.find_variations(fretboard, chord)
      fingering = Fingering.new(fretboard)
      fingerings = fingering.expand(chord.notes.first)
      
      chord.notes[1..-1].each do |note|
        fingerings = fingerings.map{|f| f.expand(note)}.flatten(1)
      end
      
      fingerings
    end
    
    private
    
    def highest_used_string
      return -1 if !@positions.any?
      indices = []
      @positions.each_with_index do |pos,i|
        indices << i unless pos.nil?
      end
      indices.max
    end
    
    def highest_note
      notes = []
      @positions.each_with_index do |pos,i|
        notes << @fretboard.open_notes[i] + pos unless pos.nil?
      end
      notes.max || -1
    end
    
  end
  
end