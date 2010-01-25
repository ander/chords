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
        if !Chords::Fretboard::TUNINGS.has_key?(t.to_sym)
          raise OptionParser::ParseError.new("Invalid tuning")
        end
        @tuning = Chords::Fretboard::TUNINGS[t.to_sym]
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
          note = Chords.const_get($1)
          begin
            chord = note.class_eval($2)
            Fretboard.new(@tuning, @frets).print(chord, 
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
                 "$ chords C.major.bass(G)\n"+
                 "$ chords -d 3 As.dim\n"+
       "$ chords -t dadgad D.minor.first_inversion\n"+
       "\nSharp notes are followed by 's' and flats by 'b', e.g. 'Gs' and 'Eb'."
    end
    
  end
end