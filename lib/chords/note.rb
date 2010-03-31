
module Chords
  NOTES = ['E', 'F', ['Fs', 'Gb'], 'G', ['Gs', 'Ab'], 'A',
           ['As', 'Bb'], ['B', 'H'], 'C', ['Cs', 'Db'], 'D', ['Ds', 'Eb']]

  module Note
    include Comparable
    attr_reader :interval, :octave

    def self.create_by_value(value)
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

    def title; self.class.title end
    
    def +(other); Note.create_by_value(value + other) end
    def -(other); Note.create_by_value(value - other) end
  end
  
  # E.g. E + 3 => G
  module NoteClassMethods
    def +(interval)
      note = NOTES.detect{|n| [n].flatten.include?(self.to_s.gsub(/^.*::/, ''))}
      idx = NOTES.index(note) + interval
      idx = idx % NOTES.size
      Chords.const_get [NOTES[idx]].flatten.first
    end
    def -(interval); self + (-interval) end
    def title; self.to_s.gsub(/^.*::/, '').sub('s', '#') end
  end
  
  NOTES.each_with_index do |names, i|
    names = [names].flatten
    names.each do |n|
      eval %Q(class #{n}
                include Note
                extend NoteClassMethods
                
                def initialize(octave=0)
                  @interval, @octave = #{i}, octave
                end
              end)
    end
  end
end