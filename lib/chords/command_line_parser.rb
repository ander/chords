require 'optparse'
require 'chords'

module Chords
  class CommandLineParser
    
    def initialize(args)
      @args = args
      @frets = Chords::Fretboard::DEFAULT_FRETS
      @duplicates = 0
      @max_fret_distance = Chords::Fingering::DEFAULT_MAX_FRET_DISTANCE
      @tuning = Chords::Fretboard::TUNINGS[:standard]
      @formatter = Chords::TextFormatter
    end
    
    def parse
      @opts = OptionParser.new
      @opts.banner = "Usage: chords [options] CHORD"
      
      @opts.on("-l", "--list", 
              "List tunings and chords.") do
        puts tunings_and_chords
        exit
      end
        
      @opts.on("-f", "--frets NUMBER_OF_FRETS",
              Integer,
              "Number of frets, i.e. max position in fingerings.") do |frets|
        @frets = frets
      end
      
      @opts.on("-d", "--duplicates DUPLICATES",
              Integer,
              "Number of duplicated notes.") do |duplicates|
        @duplicates = duplicates
      end
      
      @opts.on("-m", "--max-fret-distance MAX_FRET_DISTANCE",
              Integer,
              "Maximum distance between positions in fingering.") do |mfd|
        @max_fret_distance = mfd
      end
      
      @opts.on("-t", "--tuning TUNING", 
              "Tuning to use. See -l for list of available tunings and chords.") do |t|
        begin
          @tuning = Fretboard.send(t.downcase).open_notes
        rescue Exception => e
          raise OptionParser::ParseError.new("Invalid tuning")
        end
      end
      
      @opts.on("--pdf", "Output to pdf. Requires Prawn.") do
        begin
          require 'chords/pdf_formatter'
        rescue LoadError => e
          puts "#{e.message}\n\nMake sure you have 'prawn' gem installed."
          exit(1)
        end
        @formatter = Chords::PDFFormatter
      end
      
      @opts.on("--html", "Output to html. Requires RMagick.") do
        begin
          require 'chords/html_formatter'
        rescue LoadError => e
          puts "#{e.message}\n\nMake sure you have 'rmagick' gem installed."
          exit(1)
        end
        @formatter = Chords::HTMLFormatter
      end
      
      @opts.on_tail("-h", "--help", examples) do
        puts @opts
      end
      
      begin
        print_chord @opts.parse!(@args)
      rescue OptionParser::ParseError => e
        puts e.message
      end
    end
    
    private
    
    def print_chord(args)
      if args.size == 1
        chord_str = args.first
        chord_str =~ /^(.{1,2})\.(.*)/

        if $1 and $2 and Chords::NOTES.flatten.include?($1)
          begin
            note = Chords.const_get($1)
            chord = note.class_eval($2)
            Fretboard.new(@tuning, @frets, @formatter).print(chord, 
              {:duplicates => @duplicates,
               :max_fret_distance => @max_fret_distance})
            return
          rescue NameError => e # invalid chord variation
          end
        end
      end
      
      puts "Invalid chord."
      puts @opts
    end
    
    def tunings_and_chords
      out = "Tunings:\n=======\n"
      Chords::Fretboard::TUNINGS.each do |key, value|
        out += "#{key.to_s.ljust(12, ' ')}: #{value.map{|n| n.class.to_s.gsub(/.*::/,'')}.join(',')}\n"
      end
      out += "\nYou can also give a tuning as a string of notes, e.g. 'eadgbe'. Note that "+
             "all 'b':s are considered notes, not flats, so use 's':s for sharps instead.\n"
      out += "\nChords:\n======\n"
      Chords::ChordFactory::CHORDS.each do |key, value|
        out += "#{key}\n"
      end
      out += "\nYou can also use following modifiers on chords:\n"+
             "* first_inversion\n"+
             "* second_inversion\n"+
             "* sixth\n"+
             "* seventh\n"+
             "* add9\n"+
             "* add11\n"+
             "* bass(NOTE)\n"
    end
    
    def examples
      "\n\nExamples:\n"+
      "$ chords E.major.add9\n"+
      "$ chords \"C.major.bass(G)\"\n"+
      "$ chords -d 3 As.dim\n"+
      "$ chords -t dadgad D.minor.first_inversion\n"+
      "\nSharp notes are followed by 's' and flats by 'b', e.g. 'Gs' and 'Eb'."
    end
    
  end
end