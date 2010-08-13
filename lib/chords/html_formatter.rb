require 'chords/png_formatter'
require 'base64'

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
      @png_formatter = PNGFormatter.new(@fretboard)
    end
    
    # TODO: accept a separator element in opts
    def print(title, fingerings, opts={})
      html = "<h2>#{title}</h2>\n"
      
      fingerings.each do |fingering|
        html += get_element(fingering, opts)
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
    
    def get_element(fingering, opts)
      @cache.fetch(fingering.fid) do
        png_data = @png_formatter.print(nil, [fingering], opts)
        "<img src=\"data:image/png;base64,#{Base64.encode64(png_data)}\" />\n"
      end
    end
    
  end
  
end

# TODO: change pdf and png formatter to be required only when needed