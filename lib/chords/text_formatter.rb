
module Chords
  
  class TextFormatter
    
    def initialize(fretboard)
      @fretboard = fretboard
    end
    
    def output(fingerings)
      rows = @fretboard.open_notes.map do |open_note|
        "#{open_note.name}: "
      end
      
      fingerings.each do |fingering|
        fingering.each_with_index do |position,i|
          rows[i] += "-#{position ? position.to_s.rjust(2,'-') : '-X'}--"
        end
      end
      
      puts rows.reverse.join("\n")
    end
    
  end
  
end