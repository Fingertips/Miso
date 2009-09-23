module Miso
  class Image
    attr_reader :input_file, :processor
    
    def initialize(input_file, processor_class = Processor.processor_class)
      @processor = processor_class.new(input_file)
    end
    
    def crop(width, height)
      @processor.crop(width, height)
      self
    end
    
    def fit(width, height)
      @processor.fit(width, height)
      self
    end
    
    def dimensions
      @processor.dimensions
    end
    
    def write(output_file)
      @processor.write(output_file)
      self.class.new(output_file, @processor.class)
    end
    
    def self.crop(input_file, output_file, width, heigth, processor_class = Processor.processor_class)
      new(input_file, processor_class).crop(width.height).write(output_file)
    end
    
    def self.fit(input_file, output_file, width, height, processor_class = Processor.processor_class)
      new(input_file, processor_class).fit(width.height).write(output_file)
    end
    
    def self.dimensions(input_file, processor_class = Processor.processor_class)
      new(input_file, processor_class).dimensions
    end
  end
end