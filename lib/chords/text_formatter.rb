
module Chords
  
  class TextFormatter
    
    def initialize(fretboard)
      @fretboard = fretboard
    end
    
    def print(title, fingerings, opts={})
      rows = [""] * @fretboard.open_notes.size
      
      fingerings.each do |fingering|
        fingering.each_with_index do |position,i|
          rows[i] += "-#{position ? position.to_s.rjust(2,'-') : '-X'}--"
        end
      end
      
      idx = 0
      output = ''
      
      while rows.first.length > idx
        parts = []
        rows.each_with_index do |row, i| 
          parts << "#{@fretboard.open_notes[i].title.rjust(2, ' ')}: " + row[idx...(idx+75)]
        end
        output += "\n" + (parts.reverse.join("\n")) + "\n\n"
        idx += 75
      end
      
      output += "Total #{fingerings.size} fingerings."
      
      if opts[:inline]
        output
      else
        puts output
      end
    end
    
  end
  
end