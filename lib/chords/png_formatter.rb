require 'rvg/rvg' # rmagick's RVG (Ruby Vector Graphics) 

Magick::RVG::dpi = 72

module Chords
  
  # Formats a single fingering as png data
  class PNGFormatter
    
    def initialize(fretboard)
      @fretboard = fretboard
    end
    
    def print(title, fingerings, opts={})
      # title omitted
      raise "Please provide only one fingering" if fingerings.size != 1
      
      @max_dist = opts[:max_fret_distance] || Fingering::DEFAULT_MAX_FRET_DISTANCE
      
      get_png_data(fingerings.first)
    end
    
    private
    
    def get_png_data(fingering)
      rvg = Magick::RVG.new(5.cm, 5.cm).viewbox(0,0,270,250) do |canvas|
        canvas.background_fill = 'white'
        x_div = @fretboard.open_notes.size - 1
        
        y_diff = 215 / (@max_dist + 1)
        
        (@max_dist+2).times do |n|
          canvas.line(20, n*y_diff+20, 250, n*y_diff+20)
        end
        
        @fretboard.open_notes.each_with_index do |note, i|
          canvas.line(i*(230/x_div)+20, 20, i*(230/x_div)+20, 230)
          
          unless [0,nil].include?(fingering[i])
            canvas.circle(15, i*(230/x_div)+20, 
                          fingering.relative(@max_dist)[i]*y_diff - 5)
          end
          
          canvas.text(i*(230/x_div)+20, 15) do |txt| 
            txt.tspan((fingering[i] || 'x').to_s).styles(
                                         :text_anchor => 'middle',
                                         :font_size => 20, 
                                         :font_family => 'helvetica',
                                         :fill => 'black')
          end
          canvas.text(i*(230/x_div)+20, 249) do |txt| 
            txt.tspan(note.title).styles(:text_anchor => 'middle',
                                         :font_size => 18, 
                                         :font_family => 'helvetica',
                                         :fill => 'black')
          end
        end
        
      end
      img = rvg.draw
      img.format = 'PNG'
      img.to_blob
    end
  end
  
end

# TODO: change pdf and png formatter to be