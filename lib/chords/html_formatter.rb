require 'rvg/rvg' # rmagick's RVG (Ruby Vector Graphics) 
require 'base64'

Magick::RVG::dpi = 72

module Chords
  
  # Formats fingerings as <img/> tags (base64-encoded data URIs) 
  class HTMLFormatter
    class NonCache
      def fetch(key); yield end
    end
    
    attr_accessor :cache
    
    def initialize(fretboard, cache=NonCache.new)
      @fretboard = fretboard
      @cache = cache
    end
    
    # TODO: accept a separator element in opts
    def print(title, fingerings, opts={})
      @max_dist = opts[:max_fret_distance] || Fingering::DEFAULT_MAX_FRET_DISTANCE
      html = "<h2>#{title}</h2>\n"
      
      fingerings.each do |fingering|
        html += get_element(fingering)
      end
      
      if opts[:inline]
        html
      else 
        File.open('chords.html', 'w') do |file|
          file.write html
        end
        puts "Wrote chords.html"
      end
    end
    
    private
    
    def get_element(fingering)
      
      @cache.fetch(fingering.fid) do
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
        "<img src=\"data:image/png;base64,#{Base64.encode64(img.to_blob)}\" />\n"
      end
    end
    
  end
  
end

# TODO: change pdf and png formatter to be required only when needed