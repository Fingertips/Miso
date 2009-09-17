module Miso
  class Image
    def initialize(input_file)
      @input_file = input_file
      @operations = []
    end
    
    def crop(width, height)
      dimensions = "#{width}x#{height}"
      @operations << "-resize #{dimensions}^ -gravity center -crop #{dimensions}+0+0"
    end
    
    def fit(width, height)
      @operations << "-resize #{width}x#{height}^"
    end
    
    def dimensions
      if info = identify(input_file) and match = /\s(\d+)x(\d+)\+/.match(info)
        match.to_a[1..2]
      end
    end
    
    def write(output_file)
      convert(input_file, output_file, @operations.join(' '))
      self.class.new(output_file)
    end
    
    def self.crop(input_file, output_file, width, heigth)
      new(input_file).crop(width.height).write(output_file)
    end
    
    def self.fit(input_file, output_file, width, height)
      new(input_file).fit(width.height).write(output_file)
    end
    
    def self.dimensions(input_file)
      new(input_file).dimensions
    end
  end
end