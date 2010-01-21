require 'forwardable'

module Chords
  
  class Fingering
    DEFAULT_MAX_FRET_DISTANCE = 3
    
    extend Forwardable
    
    def_delegators :@positions, :[], :==, :inspect, :each, :each_with_index
    
    def initialize(fretboard, positions=nil)
      @fretboard = fretboard
      @positions = positions || ([nil] * @fretboard.open_notes.size)
    end
    
    def self.find_variations(fretboard, chord, opts={})
      fingering = Fingering.new(fretboard)
      fingerings = fingering.expand(chord.notes.first)
      
      chord.notes[1..-1].each do |note|
        fingerings = fingerings.map{|f| f.expand(note, opts)}.flatten(1)
      end
      
      (opts[:duplicates] || 0).times do
        fingerings = fingerings.map{|f| f.add_duplicate(opts)}.flatten(1).uniq
      end
      
      fingerings
    end
    
    # Returns all fingering variations of this fingering
    # expanded with note.
    # Expanded note wil be on a higher string than existing notes.
    # It will also be the highest note.
    def expand(note, opts={})
      max_fret_distance = opts[:max_fret_distance] || DEFAULT_MAX_FRET_DISTANCE
      
      fingerings = []
      
      ((highest_used_string+1)..(@positions.size-1)).each do |str_i|
        new_note_positions(note, str_i).each do |pos|
          if distance(pos) <= max_fret_distance and (@fretboard.open_notes[str_i] + pos) > highest_note
            new_positions = @positions.dup
            new_positions[str_i] = pos
            fingerings << Fingering.new(@fretboard, new_positions)
          end
        end
      end
      
      fingerings
    end
    
    # returns variations of this fingering with one duplicate note added
    def add_duplicate(opts={})
      return [] if unused_strings < 1
      max_fret_distance = opts[:max_fret_distance] || DEFAULT_MAX_FRET_DISTANCE
      
      fingerings = []
      
      @positions.each_with_index do |pos, i|
        next unless pos.nil?
        
        each_note do |note|
          new_note_positions(note, i).each do |pos|
            next if distance(pos) > max_fret_distance
            
            new_positions = @positions.dup
            new_positions[i] = pos
            fingerings << Fingering.new(@fretboard, new_positions)
          end
        end
      end
      
      fingerings
    end
    
    def each_note
      @positions.each_with_index do |pos, i|
        yield((@fretboard.open_notes[i] + pos).class) unless pos.nil?
      end
    end
    
    def eql?(other)
      self.hash == other.hash
    end
    
    def hash
      @positions.hash
    end
    
    private
    
    def new_note_positions(note, string_index)
      positions = []
      open_note = @fretboard.open_notes[string_index]
      pos = note.new(open_note.octave).value - open_note.value
      pos += 12 if pos < 0
      
      while pos <= @fretboard.frets
        positions << pos
        pos += 12
      end
      positions
    end
    
    def distance(position)
      pos_arr = (@positions + [position]).select{|p| !p.nil? && p > 0}
      (pos_arr.max || 0) - (pos_arr.min || 0)
    end
    
    def unused_strings
      @fretboard.open_notes.size - @positions.compact.size
    end
    
    def highest_used_string
      indices = []
      @positions.each_with_index do |pos,i|
        indices << i unless pos.nil?
      end
      indices.max || -1
    end
    
    def highest_note
      notes = []
      @positions.each_with_index do |pos,i|
        notes << @fretboard.open_notes[i] + pos unless pos.nil?
      end
      notes.max || (@fretboard.open_notes.min - 1)
    end
    
  end
  
end