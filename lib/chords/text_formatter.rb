
module Chords
  
  class TextFormatter
    
    def initialize(fretboard)
      @fretboard = fretboard
    end
    
    def output(fingerings)
      rows = [""] * @fretboard.open_notes.size
      
      fingerings.each do |fingering|
        fingering.each_with_index do |position,i|
          rows[i] += "-#{position ? position.to_s.rjust(2,'-') : '-X'}--"
        end
      end
      
      idx = 0
      while rows.first.length > idx
        parts = []
        rows.each_with_index do |row, i| 
          parts << "#{@fretboard.open_notes[i].name}: " + row[idx...(idx+75)]
        end
        puts (parts.reverse.join("\n")) + "\n\n"
        idx += 75
      end
      
      puts "Total #{fingerings.size} fingerings."
    end
    
  end
  
end