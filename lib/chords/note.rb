
module Chords
  NOTES = ['E', 'F', ['Fs', 'Gb'], 'G', ['Gs', 'Ab'], 'A',
           ['As', 'Bb'], ['B', 'H'], 'C', ['Cs', 'Db'], 'D', ['Ds', 'Eb']]

  module Note
    include Comparable
    attr_reader :interval, :name, :octave

    def self.create(value)
      octave = value / 12
      interval = value % 12
      Chords.const_get([NOTES[interval]].flatten.first).new(octave)
    end
    
    def value
      (@octave * 12) + @interval
    end

    def <=>(other)
      if other.respond_to?(:value)
        value <=> other.value
      else
        value <=> other
      end
    end

    def coerce(other)
      if other.respond_to?(:value)
        [other.value, value]
      else
        [other, value]
      end
    end

    def +(other); Note.create(value + other) end
    def -(other); Note.create(value - other) end
  end
  
  # E.g. E + 3 => G
  module NoteClassArithmetic
    def +(interval)
      Chords.const_get [NOTES[NOTES.index(self.to_s.gsub(/^.*::/, '')) + interval]].
                       flatten.first
    end
    def -(interval); self + (-interval) end
  end
  
  NOTES.each_with_index do |names, i|
    names = [names].flatten
    names.each do |n|
      eval %Q(class #{n}
                include Note
                extend NoteClassArithmetic
                
                def initialize(octave=0)
                  @interval, @octave = #{i}, octave
                end
              end)
    end
  end
end