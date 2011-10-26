module Miso
  class Image
    attr_reader :processor
    
    def initialize(input_file, processor_class=nil)
      processor_class ||= Processor.processor_class
      @processor  = processor_class.new(input_file)
    end
    
    # Basic methods
    
    def crop(width, height)
      @processor.crop(width, height)
      return self
    end
    
    def fit(width, height)
      @processor.fit(width, height)
      return self
    end
    
    def auto_orient
      @processor.auto_orient
      return self
    end
    
    def dimensions
      @processor.dimensions
    end
    
    def width
      @processor.width
    end
    
    def height
      @processor.height
    end
    
    def write(output_file)
      @processor.write(output_file)
      self.class.new(output_file, @processor.class)
    end
    
    # Combined methods
    
    def crop_fitting(width, height)
      fit(width, height).crop(width, height)
    end
    
    # Class shortcut methods
    
    def self.crop(input_file, output_file, width, height, processor_class = nil)
      new(input_file, processor_class).crop(width, height).write(output_file)
    end
    
    def self.fit(input_file, output_file, width, height, processor_class = nil)
      new(input_file, processor_class).fit(width, height).write(output_file)
    end
    
    def self.auto_orient(input_file, output_file, processor_class = nil)
      new(input_file, processor_class).auto_orient.write(output_file)
    end
    
    def self.dimensions(input_file, processor_class = nil)
      new(input_file, processor_class).dimensions
    end
  end
end