require 'chords/chord_factory'
require 'chords/fingering'
require 'chords/text_formatter'

module Chords
  
  class Fretboard
    DEFAULT_FRETS = 14
    
    # See http://en.wikipedia.org/wiki/Guitar_tunings
    TUNINGS = {
               # Some usual ones
               :standard => [E.new, A.new, D.new, G.new(1), B.new(1), E.new(2)],
               :drop_d   => [D.new(-1), A.new, D.new, G.new(1), B.new(1), E.new(2)],
               :ddd      => [D.new(-1), A.new, D.new, G.new(1), B.new(1), D.new(1)], # double-dropped D
               :dadgad   => [D.new(-1), A.new, D.new, G.new(1), A.new(1), D.new(1)],
               
               # Major open tunings
               :open_e   => [E.new, B.new, E.new(1), Gs.new(1), B.new(1), E.new(2)],
               :open_d   => [D.new(-1), A.new, D.new, Fs.new(1), A.new(1), D.new(1)],
               :open_a   => [E.new, A.new, E.new(1), A.new(1), Cs.new(1), E.new(2)],
               :open_g   => [D.new(-1), G.new, D.new, G.new(1), B.new(1), D.new(1)],
               :open_c   => [C.new(-1), G.new, C.new, G.new(1), C.new(1), E.new(2)],
               
               # Cross-note tunings
               :cross_e  => [E.new, B.new, E.new(1), G.new(1), B.new(1), E.new(2)],
               :cross_d  => [D.new(-1), A.new, D.new, F.new(1), A.new(1), D.new(1)],
               :cross_a  => [E.new, A.new, E.new(1), A.new(1), C.new(1), E.new(2)],
               :cross_g  => [D.new(-1), G.new, D.new, G.new(1), As.new(1), D.new(1)],
               :cross_c  => [C.new(-1), G.new, C.new, G.new(1), C.new(1), Ds.new(1)],
               
               # Modal tunings
               :cacgce   => [C.new(-1), A.new, C.new, G.new(1), C.new(1), E.new(2)],
               :e_modal  => [E.new, B.new, E.new(1), E.new(1), B.new(1), E.new(2)],
               :g_modal  => [G.new, G.new, D.new, G.new(1), B.new(1), D.new(1)],
               :gsus2    => [D.new(-1), G.new, D.new, G.new(1), A.new(1), D.new(1)],
               :c15      => [C.new(-1), G.new, D.new, G.new(1), C.new(1), D.new(1)],
               
               # "Extended chord" tunings
               :dmaj7    => [D.new(-1), A.new, D.new, Fs.new(1), A.new(1), Cs.new(1)],
               
               # Other instruments
               :mandolin => [G.new, D.new, A.new(1), E.new(2)],
               :ukulele  => [G.new, C.new, E.new(1), A.new(1)],
               :banjo    => [G.new, D.new, G.new(1), B.new(1), D.new(1)]
              }
    
    attr_reader :frets, :open_notes, :formatter
    
    def initialize(open_notes, frets=DEFAULT_FRETS, formatter_class=TextFormatter)
      @open_notes, @frets = open_notes, frets
      @formatter = formatter_class.new(self)
    end
    
    # Creates a new fretboard, parsing the open notes from the open_notes_str.
    # All 'b':s are interpreted as B-notes, not flats, so use 's' for sharps instead.
    def self.new_by_string(open_notes_str, frets=DEFAULT_FRETS, 
                           formatter_class=TextFormatter)
      open_notes_str.upcase!
      raise "Provide at least 3 strings" if open_notes_str.scan(/[^S]/m).size < 3
      open_notes = []
      
      open_notes_str.scan(/./m).each do |chr|
        if chr == 'S'
          raise "Invalid tuning!" if open_notes.empty?
          open_notes[open_notes.size-1] += 1
        else
          open_notes << Chords.const_get(chr).new
        end
      end
      
      (1..(open_notes.size-1)).each do |i|
        open_notes[i] += 12 while open_notes[i-1] > open_notes[i]
      end
      
      Fretboard.new(open_notes, frets, formatter_class)
    end
    
    def self.method_missing(meth, *args)
      if TUNINGS.has_key?(meth)
        Fretboard.new(TUNINGS[meth], (args[0] || DEFAULT_FRETS),
                      args[1] || TextFormatter)
                      
      elsif meth.to_s =~ /^[efgabhcds]+$/
        Fretboard.new_by_string(meth.to_s, (args[0] || DEFAULT_FRETS),
                                args[1] || TextFormatter)
      
      else
        super
      end
    end
    
    def find(chord, opts={})
      Fingering.find_variations(self, chord, opts)
    end
    
    def print(chord, opts={})
      fingerings = find(chord, opts)
      @formatter.print(chord.title, fingerings, opts)
    end
    
    # Method for printing a single fingering using Fingering#fid,
    # which contains also the tuning/fretboard used.
    # Doesn't handle big max_fret_distances right.
    def self.print_fingering_by_fid(fid, opts={}, formatter_class=TextFormatter)
      fingering_part = fid.split(/[efgabhcds]/).last
      raise "Invalid fingering" if fingering_part.nil?
      tuning_part = fid.sub(fingering_part, '')
      
      fretboard = Fretboard.new_by_string(tuning_part, 50, formatter_class)
      
      positions = parse_positions(fingering_part, fretboard.open_notes.size)
      
      fingering = Fingering.new(fretboard, positions)
      max_fret_dist = fingering.max_fret_distance
      max_fret_dist = 2 if max_fret_dist < 2
                                                     
      fretboard.formatter.print('', [fingering],
                                opts.merge(:max_fret_distance => max_fret_dist))
    end
    
    # parse positions from a string, for example '022100'
    # returns [0,2,2,1,0,0] if no_of_string is six
    def self.parse_positions(position_str, no_of_strings)
      position_str.downcase!
      positions = position_str.scan(/./).map{|pos| pos == 'x' ? nil : pos.to_i}
      over_tens = positions.size - no_of_strings
      
      while over_tens > 0
        idx = positions.index{|p| !p.nil? and p > 0 and p < 3}
        if idx
          positions[idx] = "#{positions[idx]}#{positions[idx+1]}".to_i
          positions.delete_at(idx+1)
        end
        over_tens -= 1
      end
      
      positions
    end
    
  end
end