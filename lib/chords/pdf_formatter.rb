
require 'prawn'
require 'prawn/layout'

module Chords
  
  class PDFFormatter
    
    def initialize(fretboard)
      @fretboard = fretboard
    end
    
    def print(fingerings, opts={})
      @pdf = Prawn::Document.new
      @pdf.define_grid(:columns => 4, :rows => 6, :gutter => 40)
      @max_dist = opts[:max_fret_distance] || Fingering::DEFAULT_MAX_FRET_DISTANCE
      
      fingerings.each_with_index do |f, i|
        print_fingering(f, i)
      end
      
      @pdf.render_file('chords.pdf')
      puts "Wrote chords.pdf"
    end
    
    private
    
    def string_x_dist(box)
      box.width / (@fretboard.open_notes.size - 1)
    end
    
    def string_y_dist(box)
       box.height / (@max_dist + 1)
    end
    
    def get_box(i)
      @pdf.grid(i / 4, i % 4)
    end
    
    def print_fretboard(i)
      box = get_box(i)
      
      @pdf.mask(:line_width) do
        @pdf.line_width 3
        @pdf.stroke_line box.top_left, box.top_right
        @pdf.line_width 1
        @pdf.stroke_line box.bottom_left, box.bottom_right
        
        @fretboard.open_notes.size.times do |n|
          x = box.left + n*string_x_dist(box)
          @pdf.stroke_line [x, box.top], [x, box.bottom]
        end
        
        @max_dist.times do |n|
          y = box.top - ((n+1) * string_y_dist(box))
          @pdf.stroke_line [box.left, y], [box.right, y]
        end 
      end
    end
    
    def print_fingering(fingering, i)
      print_fretboard(i)
      
      box = get_box(i)
      
      rad = ([string_y_dist(box), string_x_dist(box)].min / 2) - 4
      
      fingering.each_with_index do |pos, pos_i|
        x_adj = pos.to_s.length > 1 ? -6 : -3
        @pdf.draw_text((pos || 'x').to_s, 
                      :at => [box.left + pos_i*string_x_dist(box) + x_adj, box.top + 3])
        
        next if [nil, 0].include?(pos)
        
        @pdf.fill_and_stroke do
          @pdf.circle_at [box.left + (pos_i * (string_x_dist(box))), 
                          box.top + (string_y_dist(box) / 2) -
                          (fingering.relative(@max_dist)[pos_i] * string_y_dist(box))], 
                          :radius => rad
        end        
      end
    end
  end
  
end